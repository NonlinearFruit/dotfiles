# Ideas

- Internet Archive to Creeds.json
- CLI `man curl | llm 'how to print only the status code'`

# Resources

- Modelfile docs: <https://github.com/ollama/ollama/blob/main/docs/modelfile.md>
- Api docs: <https://github.com/ollama/ollama/blob/main/docs/api.md>

# Setup Ollama

<https://github.com/ollama/ollama>

```sh
z dotfiles
podman run -d -v ./ollama:/root/dotfiles:z -p 11434:11434 --name ollama ollama/ollama
```

# Setup Web UI

<https://github.com/open-webui/open-webui>

# Create a model

```sh
# Make the model file
podman exec -it ollama sh
ollama create <name> --file <path-to-modelfile>
ollama run <name>
>>> chat with the llm
>>> /save /path/some_chat_with_the_llm
>>> /bye
ollama show <name> --modelfile
ollama show <name> --parameters
```


