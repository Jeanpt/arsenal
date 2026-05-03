# 404 Error Page Cheatsheet

Identifying the web framework or server from default error pages. Useful when there's no `Server:` header or when you want to confirm what you're dealing with before picking an attack path.

Hit a non-existent path on the target (`/doesnotexist`) and match the response below.

---

## Web Servers

| Server | Response signature |
|---|---|
| **nginx** | `<center><h1>404 Not Found</h1></center><hr><center>nginx/x.x.x</center>` |
| **Apache** | `<h1>Not Found</h1><p>The requested URL was not found on this server.</p>` |
| **IIS** | Styled HTML, gray color scheme, "404 - File or directory not found" |

---

## Python Frameworks

| Framework | Response signature |
|---|---|
| **Flask** | `<!doctype html><html lang=en><title>404 Not Found</title><h1>Not Found</h1>` |
| **Django** | Minimal HTML, no version details |
| **FastAPI** | JSON: `{"detail":"Not Found"}` |
| **AIOHTTP** | Plain text: `404: Not Found` (no HTML at all) |

---

## PHP Frameworks

| Framework | Response signature |
|---|---|
| **PHP-FPM** | Plain text: `File not found.` |
| **Laravel** | Styled HTML, centered div with error layout |
| **Symfony** | "Oops! An Error Occurred" with error description template |

---

## Node.js Frameworks

| Framework | Response signature |
|---|---|
| **Express** | `<pre>Cannot GET /path</pre>` |
| **Next.js** | Complex HTML with React hydration scripts |

---

## Go Frameworks

| Framework | Response signature |
|---|---|
| **Fiber** | Plain text: `Cannot POST /path` |
| **Gin** | Plain text: `404 page not found` |

---

## Java Frameworks

| Framework | Response signature |
|---|---|
| **Tomcat** | Styled HTML: "HTTP Status 404 – Not Found" |
| **Spring Boot** | "Whitelabel Error Page" with timestamp |
| **Jetty** | HTML table listing server contexts |

---

## Ruby Frameworks

| Framework | Response signature |
|---|---|
| **Rails** | "The page you were looking for doesn't exist (404)" |
| **Sinatra** | Shows requested path and code template suggestion |

---

## .NET Frameworks

| Framework | Response signature |
|---|---|
| **ASP.NET** | Styled error page, red header, resource description |
| **Blazor** | "Sorry, there's nothing at this address." |

---

## Tips

- Check the `Server:` response header first — it often leaks the server/framework directly.
- Look at response body length and format: JSON = likely API framework, plain text = Go/AIOHTTP/PHP-FPM, rich HTML = Laravel/Spring/Rails.
- Version strings in nginx/Apache 404s can be used to look up known CVEs.

---

> Source: https://0xdf.gitlab.io/cheatsheets/404
