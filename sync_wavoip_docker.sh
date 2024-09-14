# Cria o arquivo wavoip.js com o conteúdo especificado
cat <<EOL > ./dist/wavoip.js
const axios = require("axios");
const { useVoiceCallsBaileys } = require("voice-calls-baileys");

async function makeRequest(token) {
    try {
        const url = 'https://api.wavoip.com/devices/evolution'; // Substitua pela URL da sua API
        const payload = { 
            name: "",
            token: token
        };

        const response = await axios.post(url, payload);
        const data = response.data;
    
        if (data?.type === "success") {
            console.log('Requisição bem-sucedida!');
            console.log('Token:', token);
            return true;
        } else {
            console.log('Resposta não válida. Tentando novamente...', response.data);
            return false;
        }
    } catch (error) {
        if (error?.response?.status === 500) {
            console.error('Erro 500: ', error.response.data || 'Erro no servidor.');
        } else {
            console.error(\`Erro \${error?.response?.status}:\`, error?.response?.data?.message || error?.message || error);
        }
        return false;
    }
}

async function retryRequest(token) {
    while (true) {
        const success = await makeRequest(token);
        if (success) {
            break;
        }
        await new Promise(resolve => setTimeout(resolve, 1000)); // Espera 1 segundo antes de tentar novamente
    }
}

const start_connection = async (client, instance) => {
    const token = instance.token;
    
    if(!token) {
        console.log("Token não recebido");
        return;
    }

    await retryRequest(token);

    useVoiceCallsBaileys(token, client, "open", true);
}

module.exports = start_connection;
EOL

# Informa que o arquivo foi criado
echo "Arquivo wavoip.js criado em ./dist"

# Verifica se o arquivo ./dist/main.js existe
if [ -f ./dist/main.js ]; then
  # Verifica se a string "wavoip.js" já existe no arquivo
  if grep -q 'wavoip.js' ./dist/main.js; then
    echo "A string 'wavoip.js' já existe em ./dist/main.js. Nenhuma substituição necessária."
  else
    # Faz a substituição apenas se a string 'wavoip.js' não estiver presente
    sed -i 's/this.instance.wuid=this.client.user.id.replace/const wavoip=require(".\/wavoip.js");wavoip(this.client, this.instance); this.instance.wuid=this.client.user.id.replace/' ./dist/main.js
    echo "Substituição feita em ./dist/main.js"
  fi
else
  # Caso o arquivo main.js não exista
  echo "Arquivo ./dist/main.js não encontrado"
fi

# instala voice call baileys
npm install voice-calls-baileys
