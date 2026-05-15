# ── Etapa 1: builder ──────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ── Etapa 2: runtime ──────────────────────────────────────────
FROM nginxinc/nginx-unprivileged:1.27-alpine AS runtime

COPY --from=builder --chown=nginx:nginx /app/dist/casino-frontend/browser/ /usr/share/nginx/html/

# ← Va a templates/ para que envsubst procese ${BACKEND_HOST}
COPY --chown=nginx:nginx nginx.conf /etc/nginx/templates/default.conf.template

USER nginx
EXPOSE 8080