const http = require('http');
const port = 8080;

const server = http.createServer((req, res) => {
  // Basic request logging for CloudWatch
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);

  if (req.url === '/health') {
    console.log('Health check OK');
    res.writeHead(200, {'Content-Type':'text/plain'});
    res.end('ok');
    return;
  }

  console.log('Handling root request');
  res.writeHead(200, {'Content-Type':'text/plain'});
  res.end('Hello from private EC2!');
});

server.listen(port, () => {
  console.log('Server listening on ' + port);
});
