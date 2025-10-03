# 1. Gunakan base image resmi Python 3.12.7 (sesuai workflow CI/CD)
FROM python:3.12.7-slim

# 2. Tentukan direktori kerja di dalam container
WORKDIR /app

# 3. Terima RUN_ID sebagai argumen saat build
ARG RUN_ID

# 4. Salin file requirements terlebih dahulu untuk optimasi cache Docker
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

# 5. Salin folder MLproject yang berisi mlruns dan model ke dalam container
#    Dilakukan setelah instalasi agar perubahan kode tidak membuat pip install diulang
COPY MLproject/ /app/

# 6. Expose port server
EXPOSE 8080

# 7. Set environment variable untuk menunjuk ke lokasi model
#    Variabel ${RUN_ID} dari ARG akan otomatis diexpand di sini
ENV MODEL_URI=/app/mlruns/0/${RUN_ID}/artifacts/model

# 8. Jalankan server MLflow (INI BAGIAN YANG DIPERBAIKI)
#    Gunakan format shell agar variabel $MODEL_URI terbaca
CMD mlflow models serve -h 0.0.0.0 -p 8080 --model-uri $MODEL_URI
