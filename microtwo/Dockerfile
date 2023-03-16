FROM node
LABEL project="mockapp"
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3002
CMD ["npm", "start"]