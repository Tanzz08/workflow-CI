# 1. Gunakan base image resmi Python 3.10 yang stabil dan ringan
FROM python:3.10-slim

# 2. Tentukan direktori kerja di dalam container
WORKDIR /app

# 3. Salin folder MLproject yang berisi mlruns dan model ke dalam container
COPY MLproject/ /app/

# 4. Terima RUN_ID sebagai argumen saat build
# Nilai ini akan diberikan oleh workflow GitHub Actions
ARG RUN_ID

# 5. Instal dependensi yang dibutuhkan oleh model
# MLflow secara otomatis membuat file ini untuk setiap model yang disimpan
RUN pip install --no-cache-dir -r /app/mlruns/0/${RUN_ID}/artifacts/model/requirements.txt

# 6. Expose port yang akan digunakan oleh server MLflow
EXPOSE 8080

# 7. Atur environment variable untuk menunjuk ke lokasi model di dalam container
ENV MODEL_URI=/app/mlruns/0/${RUN_ID}/artifacts/model

# 8. Perintah default untuk menjalankan server prediksi saat container dimulai
# Server akan mendengarkan di semua interface (-h 0.0.0.0)
CMD ["mlflow", "models", "serve", "-h", "0.0.0.0", "-p", "8080", "--model-uri", "$MODEL_URI"]
