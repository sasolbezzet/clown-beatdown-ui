---
name: my-ai-agent
description: Simple conversational AI agent that can answer questions, perform web lookups, and use OpenClaw tools for tasks like file read/write, exec, and browser automation.
---

# My AI Agent

## Overview
This agent acts as a general‑purpose assistant. When invoked, it can:
- Answer factual questions using `web_search` or `web_fetch`.
- Perform simple file operations (`read`, `write`, `edit`).
- Execute shell commands (`exec`) when the user explicitly requests it.
- Interact with the browser via the `browser` tool for multi‑step web workflows.
- Retrieve the current date/time with `session_status`.
- Access the long‑term memory (`memory_search`/`memory_get`) for prior context.

## Activation
The agent is triggered when the user asks for a “AI assistant”, “chatbot”, or any request that does not match a more specific existing skill.

## Core Workflow
1. **Identify intent** – Determine whether the request is a question, a task, or a tool‑specific command.
2. **Select tool** – Use the appropriate first‑class tool (e.g., `web_search` for up‑to‑date info, `read` for local files, `exec` for command execution).
3. **Execute & gather results** – Run the tool, optionally iterate if more data is needed.
4. **Compose response** – Summarize findings, cite sources (`Source: <path#line>`), and include any required output (e.g., `MEDIA:` attachment lines).

## Safety Guidelines
- Never run destructive commands (`rm -rf /`, `shutdown`, etc.) without explicit user approval.
- Respect user privacy – do not share contents of `MEMORY.md` or personal files unless the user asks.
- If a tool call fails, report the error and propose an alternative.

## Example Interactions
### Simple factual query
User: "Siapa presiden Indonesia saat ini?"
- Agent calls `web_search` with query "presiden Indonesia".
- Returns the top result and cites the source.

### File read
User: "Baca isi file /home/ubuntu/.openclaw/workspace/README.md"
- Agent calls `read` on the path and returns the content.

### Command execution
User: "Tunjukkan proses git status di repositori saat ini."
- Agent asks for clarification if the repo directory is known, then runs `exec` with `git status`.
- Returns the command output.

## Extending the Agent
If you need more domain‑specific behavior, add reference files under `reference/` and update the SKILL.md to `read` them conditionally. For example, a `reference/finance.md` could be loaded for financial queries.

## End of Skill
This skill provides a solid foundation for a versatile AI assistant within OpenClaw. Adjust the description or add more detailed guidance as your workflow evolves.
