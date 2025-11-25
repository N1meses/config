import os, json
from typing import Dict, List
from openai import OpenAI

SYSTEM_PROMPT = """## Behavior
- Always answer directly and concisely.
- Prefer facts over speculation.
- Never insert filler, exclamations, or unnecessary commentary.
- Stay calm and impersonal. No emotions or anthropomorphism.
- Use the same language as the user.
- State uncertainties explicitly when relevant.
- For code or technical output, use proper syntax-highlighted code blocks.
- Do not repeat the user’s question before answering.

## Knowledge and Sources
- Base responses on verifiable facts and publicly available documentation.
- When unsure or outdated, state the uncertainty instead of guessing.
- Do not fabricate data, versions, or quotes.

## Formatting
- Lists and tables are acceptable where clarity improves.
- Avoid decorative characters, emojis, or narrative tone.
- For long outputs, structure logically with clear section headers.

## User Alignment
- Prioritize solving the user’s explicit task.
- When multiple interpretations exist, ask clarifying questions first.
- Never assume personal preferences or emotions for the user.
"""

class Program:
    def __init__(self):
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.directory = "/home/nimeses/chats"
        self.convo = ""
        self.history: List[Dict[str, str]] = []
        self.temp = False
        os.makedirs(self.directory, exist_ok=True)

    def list_chats(self):
        files = [f[:-5] for f in os.listdir(self.directory) if f.endswith(".json")]
        if files:
            print("\nSaved conversations:")
            for name in sorted(files):
                print(f"  {name}")
            print()
        else:
            print("\nNo saved conversations.\n")

    def listener(self):
        while True:
            prompt = input(f"--{self.convo if self.convo else 'new'} You: ").strip()
            if not prompt:
                continue
            low = prompt.lower()

            if low in ("exit", "quit"):
                break

            # flags
            parts = prompt.split()
            if parts[0].startswith("--"):
                if parts[0] == "--help":
                    print("""
Flags:
  --list                 list saved conversations
  --temp [prompt]        temporary chat (not saved)
  --<name> [prompt]      use or create saved chat <name>
  --help                 show this message
  --save <name>          saves the temporary chat with <name> 
""")
                    continue
                if parts[0] == "--list":
                    self.list_chats()
                    continue

                if parts[0] == "--temp":
                    self.temp = True
                    self.convo = "temp"
                    self.history = [{"role": "system", "content": SYSTEM_PROMPT}]
                    prompt = " ".join(parts[1:]).strip()
                    if not prompt: continue

                if parts[0] == "--save" and len(parts) >= 2:
                    name = parts[1]
                    self.temp = False
                    self.convo = name
                    self.save_history()
                    print(f"saved as '{name}'")
                    continue

                elif parts[0].startswith("--") and parts[0] not in ("--temp", "--help", "--list", "--save"):
                    self.temp = False  # <- leaving temp
                    self.convo = parts[0].lstrip("-")
                    self.history = self.load_history()

                else:
                    # --<name>
                    self.temp = False
                    self.convo = parts[0].lstrip("-")
                    self.history = self.load_history()
                    prompt = " ".join(p for p in parts[1:]).strip()
                    if not prompt:
                        continue

            # Check for multiline start marker
            if prompt == "//s":
                print("Multiline mode - type //e to finish")
                multiline_content = []
                while True:
                    line = input("> ")
                    if line.strip() == "//e":
                        break
                    multiline_content.append(line)
                
                prompt = "\n".join(multiline_content)
                if not prompt.strip():  # Skip if empty
                    continue

            # normal message
            self.history.append({"role": "user", "content": prompt})
            self.chat()
            if not self.temp:
                self.save_history()

    def load_history(self) -> List[Dict[str, str]]:
        path = os.path.join(self.directory, f"{self.convo}.json")
        if os.path.exists(path):
            with open(path) as f:
                return json.load(f)
        # new convo with system prompt
        return [{"role": "system", "content": SYSTEM_PROMPT}]

    def save_history(self):
        if self.temp:  # <- never persist temp
            return
        path = os.path.join(self.directory, f"{self.convo}.json")
        with open(path, "w") as f:
            json.dump(self.history, f, indent=2, ensure_ascii=False)

    def chat(self) -> None:
        resp = self.client.chat.completions.create(
            model="gpt-5",  # or a model you have access to
            messages=self.history,  # list of dicts with role/content
            # stream omitted → default mode
        )
        reply = resp.choices[0].message.content or ""
        print("Assistant:", reply)
        self.history.append({"role": "assistant", "content": reply})

if __name__ == "__main__":
    Program().listener()
