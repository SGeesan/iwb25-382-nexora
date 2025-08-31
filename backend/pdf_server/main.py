import uuid
import shutil
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from pdf2image import convert_from_path
from pathlib import Path
import uvicorn

app = FastAPI()

# Allow call backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

UPLOAD_DIR = Path("./uploads")
OUTPUT_DIR = Path("./output")

UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


@app.post("/upload")
async def upload_pdf(pdf: UploadFile = File(...)):
    if not pdf.filename.endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files allowed")

    file_uuid = str(uuid.uuid4())
    save_path = UPLOAD_DIR / f"{file_uuid}.pdf"

    with open(save_path, "wb") as f:
        f.write(await pdf.read())

    return {"uuid": file_uuid}


@app.get("/pdf/{file_uuid}")
async def get_pdf_images(file_uuid: str):
    pdf_path = UPLOAD_DIR / f"{file_uuid}.pdf"
    if not pdf_path.exists():
        raise HTTPException(status_code=404, detail="PDF not found")

    output_path = OUTPUT_DIR / file_uuid
    output_path.mkdir(parents=True, exist_ok=True)

    # Convert only if not already converted
    if not any(output_path.iterdir()):
        images = convert_from_path(str(pdf_path))
        for i, img in enumerate(images):
            img.save(output_path / f"page_{i+1}.jpg", "JPEG")

    # Count pages
    page_files = sorted(output_path.glob("*.jpg"))
    page_count = len(page_files)
    files = [f"/image/{file_uuid}/{i+1}" for i in range(page_count)]

    return {"uuid": file_uuid, "page_count": page_count, "images": files}


@app.get("/image/{file_uuid}/{page}")
async def get_image(file_uuid: str, page: int):
    image_path = OUTPUT_DIR / file_uuid / f"page_{page}.jpg"
    if not image_path.exists():
        raise HTTPException(status_code=404, detail="Image not found")
    return FileResponse(image_path)


@app.delete("/pdf/{file_uuid}")
async def delete_pdf(file_uuid: str):
    pdf_path = UPLOAD_DIR / f"{file_uuid}.pdf"
    output_path = OUTPUT_DIR / file_uuid

    if not pdf_path.exists():
        raise HTTPException(status_code=404, detail="PDF not found")

    # Delete PDF file
    pdf_path.unlink(missing_ok=True)

    # Delete converted images folder
    if output_path.exists():
        shutil.rmtree(output_path)

    return {"status": "deleted", "uuid": file_uuid}


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
