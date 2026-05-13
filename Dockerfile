# ── Etapa 1: builder ──────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ── Etapa 2: runtime ──────────────────────────────────────────
FROM nginxinc/nginx-unprivileged:alpine AS runtime

COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

USER nginx

CMD ["nginx", "-g", "daemon off;"]