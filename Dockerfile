FROM ghcr.io/tinfoilanalytics/nitro-attestation-shim:v0.1.5 AS shim

FROM ollama/ollama

RUN apt update -y
RUN apt install -y iproute2

COPY --from=shim /nitro-attestation-shim /nitro-attestation-shim

ENV HOME=/

RUN nohup bash -c "ollama serve &" && sleep 5 && ollama pull llama3.2:1b

ENTRYPOINT ["/nitro-attestation-shim", "-d", "*.bravo.tinfoil.sh", "-e", "tls@tinfoil.sh", "-p", "/api/chat", "-u", "11434", "-c", "7443", "-l", "443", "--", "/bin/ollama", "serve"]
