# 1. Gunakan base image resmi Python 3.12.7 (sesuai workflow CI/CD)
FROM python:3.12.7-slim

# 2. Tentukan direktori kerja di dalam container
WORKDIR /app

# 3. Salin folder MLproject yang berisi mlruns dan model ke dalam container
COPY MLproject/ /app/

# 4. Terima RUN_ID sebagai argumen saat build
ARG RUN_ID

# 5. Instal dependensi yang dibutuhkan
# --- Ganti: jangan ambil dari mlruns (karena requirements.txt tidak selalu ada)
# --- Pakai requirements.txt manual yang kita sediakan
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

# 6. Expose port server
EXPOSE 8080

# 7. Set environment variable untuk menunjuk ke lokasi model
ENV MODEL_URI=/app/mlruns/0/${RUN_ID}/artifacts/model

# 8. Jalankan server MLflow
CMD ["mlflow", "models", "serve", "-h", "0.0.0.0", "-p", "8080", "--model-uri", "/app/mlruns/0/${RUN_ID}/artifacts/model"]
