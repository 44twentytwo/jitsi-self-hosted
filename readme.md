## How to deploy
### Prepare a DNS A record pointing to the server
### Clone the rep
```
git clone https://github.com/44twentytwo/jisti-self-hosted /opt/jitsi
cd /opt/jitsi
```
### Create a `.env` file from the template
`cp .env.example .env`
### Generate secrets:
```
openssl rand -hex 16 | tee /tmp/JICOFO_COMPONENT_SECRET
openssl rand -hex 16 | tee /tmp/JICOFO_AUTH_PASSWORD
openssl rand -hex 16 | tee /tmp/JVB_AUTH_PASSWORD
```

### Run the script
`bash scripts/bootstrap.sh`
