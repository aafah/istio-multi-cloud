FROM node:alpine
LABEL project="mockapp"
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN apk add --no-cache curl
EXPOSE 3000
CMD ["npm", "start"]
