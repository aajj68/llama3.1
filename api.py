import requests

# URL da API e da interface web
API_URL = "http://localhost:9090/api/v1/chat"
WEBUI_URL = "http://localhost:9095/"

def chat_with_llama(prompt):
    response = requests.post(API_URL, json={"prompt": prompt})
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": response.text}

def main():
    # Exemplo de conversa
    prompt = "Qual é a capital da França?"
    result = chat_with_llama(prompt)
    print("Resposta do LLaMA:", result)

if __name__ == "__main__":
    main()
