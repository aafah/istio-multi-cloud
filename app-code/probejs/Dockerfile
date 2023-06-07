FROM node:alpine
LABEL project="mockapp"
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN apk add --no-cache openssl jq curl
EXPOSE 3001
CMD ["npm", "start"]