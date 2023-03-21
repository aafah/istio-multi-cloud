FROM node:alpine
LABEL project="mockapp"
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3003
CMD ["npm", "start"]