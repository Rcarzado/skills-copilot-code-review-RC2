# Copilot instructions for this repository



## Security

- Validate input sanitization practices.
- Search for risks that might expose user data.
- Prefer loading configuration and content from the database instead of hard coded content. If absolutely necessary, load it from environment variables or a non-committed config file.

## Code Quality

- Use consistent naming conventions.
- Try to reduce code duplication.
- Prefer maintainability and readability over optimization.
- If a method is used a lot, try to optimize it for performance.
- Prefer explicit error handling over silent failures.




## Project overview
- Backend: FastAPI app in `src/app.py`.
- API routers: `src/backend/routers/activities.py` and `src/backend/routers/auth.py`.
- Data layer: MongoDB collections in `src/backend/database.py`.
- Frontend: static files in `src/static/` (`index.html`, `app.js`, `styles.css`).

## Architecture and data conventions
- Activities use activity name as MongoDB `_id`.
- Teachers use username as MongoDB `_id`.
- Router paths should remain under existing prefixes:
  - `/activities`
  - `/auth`
- Keep API response shapes stable unless a task explicitly asks for a breaking change.

## Python coding rules
- Preserve current style: type hints where already used, clear function names, short docstrings.
- Do not add new dependencies unless strictly necessary.
- Keep imports local to existing package layout (`from ..database import ...` inside routers).
- Prefer explicit error handling with `HTTPException` and accurate status codes.

## Frontend coding rules
- Use plain JavaScript patterns already in `src/static/app.js` (no framework introduction).
- Reuse existing DOM ids/classes from `index.html`; avoid renaming identifiers unless required.
- Keep user-facing messages short and consistent with current tone.

## Security and auth expectations
- Never return password hashes in API responses.
- Keep auth validation server-side for protected actions.
- Maintain Argon2 password verification flow from `database.py`.

## Scope and change discipline
- Make minimal, targeted changes for each task.
- Avoid unrelated refactors or formatting-only edits.
- When modifying endpoints, keep backward compatibility where feasible.

## Local run and validation
- Start API: `python -m uvicorn src.app:app --host 0.0.0.0 --port 8000`
- In devcontainer, ensure MongoDB is running: `bash ./.devcontainer/startMongoDB.sh`
- Validate syntax quickly when needed:
  - `python -m py_compile src/app.py src/backend/database.py`

## Documentation expectations
- If behavior changes, update `src/README.md` endpoint notes accordingly.
