FROM ghcr.io/tinfoilanalytics/nitro-attestation-shim:v0.2.2 AS shim

FROM ollama/ollama

RUN apt update -y
RUN apt install -y iproute2

COPY --from=shim /nitro-attestation-shim /nitro-attestation-shim

ENV HOME=/

RUN nohup bash -c "ollama serve &" && sleep 5 && ollama pull llama3.2:1b

ENTRYPOINT ["/nitro-attestation-shim", "-e", "tls@tinfoil.sh", "-p", "/api/chat", "-p", "/v1/chat/completions", "-u", "11434", "--", "/bin/ollama", "serve"]
