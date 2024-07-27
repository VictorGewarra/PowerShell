const express = require('express');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');
const fs = require('fs'); // Импорт модуля fs
const path = require('path');


const app = express();
app.use(bodyParser.json());
app.use(express.text());
app.use(express.static(path.join(__dirname, 'public')));

app.post('/submit-code', (req, res) => {
    const code = req.body; // Получаем текстовые данные из тела запроса
    const functionsFilePath = path.join(__dirname, 'tests', 'functions.ps1');

    // Проверяем, что данные являются строкой
    if (typeof code !== 'string') {
        console.error('Полученные данные не являются строкой');
        return res.status(400).send('Ожидалась строка');
    }

    // Записываем код в файл
    fs.writeFile(functionsFilePath, code, 'utf8', (err) => {
        if (err) {
            console.error('Ошибка записи файла:', err);
            return res.status(500).send('Ошибка записи файла');
        }
        res.send('Код успешно сохранен');
    });
});
app.post('/execute', (req, res) => {
    const command = req.body.command;
    console.log(`Received command: ${command}`); // Логируем команду для отладки

    const ps = spawn('powershell.exe', ['-NoProfile', '-Command', command]);

    let output = '';
    let errorOutput = '';

    ps.stdout.on('data', (data) => {
        output += data.toString();
    });

    ps.stderr.on('data', (data) => {
        errorOutput += data.toString();
    });

    ps.on('close', (code) => {
        if (code !== 0) {
            console.error(`Error executing command: ${errorOutput}`); // Логируем ошибку для отладки
            res.status(500).send(`Error executing command: ${errorOutput}`);
        } else {
            res.send(output);
        }
    });

    ps.on('error', (err) => {
        console.error(`Failed to start subprocess: ${err.message}`); // Логируем ошибку для отладки
        res.status(500).send(`Failed to start subprocess: ${err.message}`);
    });
});

app.post('/run-tests', (req, res) => {
    const { testFileName } = req.body;
    const testFilePath = path.join(__dirname, 'tests', testFileName);

    // Запускаем PowerShell, загружаем функции и затем запускаем Pester
    const ps = spawn('powershell.exe', ['-NoProfile', '-Command', `
        . ${path.join(__dirname, 'tests', 'functions.ps1')};
        Invoke-Pester -Path ${testFilePath}
    `]);

    let output = '';
    ps.stdout.on('data', (data) => {
        output += data;
    });

    ps.stderr.on('data', (data) => {
        output += data;
    });

    ps.on('close', (code) => {
        res.send(output);
    });
});

const port = 3000;
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
