# Використовуємо офіційний легковаговий образ Python на базі Alpine
FROM python:3.12-alpine

# Налаштовуємо змінні оточення:
# PYTHONDONTWRITEBYTECODE - не створювати .pyc файли
# PYTHONUNBUFFERED - виводити логи в термінал миттєво (важливо для Docker logs)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Створюємо непривілейованого користувача та групу для FinTech-безпеки (UID/GID 10001)
RUN addgroup -g 10001 -S appgroup && \
    adduser -u 10001 -S appuser -G appgroup

WORKDIR /app

# Копіюємо код програми і змінюємо власника на non-root користувача
COPY --chown=appuser:appgroup api.py .

# Перемикаємось на непривілейованого користувача
USER appuser

# Відкриваємо порт застосунку
EXPOSE 8080

# Запускаємо сервіс
CMD ["python", "api.py"]
