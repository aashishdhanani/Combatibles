# Combatibles

What you will need to run the frontend:
- {something here}

What you will need to run the server:
- [Python >3](https://www.python.org/)
- [Pip](https://pypi.org/project/pip/)
- Azure OpenAI API Key, endpoint, and version

## Run the frontend

## Run the server
1. Navigate to the terminal in your preferred IDE
   
2. Install the requirements

```source-shell
pip install -r requirements.txt
```

4. Add your AzureOpenAI API key, your Azure endpoint, and your AzureOpenAI version to your .env file

```source-shell
AZURE_OPENAI_API_KEY=[YOUR_OPEN_AI_KEY]
AZURE_ENDPOINT=[YOUR_AZURE_ENDPOINT]
AZURE_OPENAI_VERSION=[YOUR_AZURE_OPENAI_VERSION]
```

3. Start server

```source-shell
python3 manage.py runserver
```

5. Navigate to the localhost site

```source-shell
http://[IP_ADDRESS]:[PORT_NUM]/
```
