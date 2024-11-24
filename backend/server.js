import express from "express";
import mysql from "mysql";
import cors from "cors";
import path from "path"; // Importa path para rutas relativas y absolutas
import nodemailer from "nodemailer";
const app = express();
const PORT = 3002;
// Middleware para servir la carpeta de imágenes como estática
const __dirname = path.resolve();
app.use("/img", express.static(path.join(__dirname, "../img")));


// import nodemailer from "nodemailer";

const userGmail = "acopioemails@gmail.com";
const passAppGmail = "lioy pwrj ndph tgan";

// Set up Nodemailer transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: userGmail,
    pass: passAppGmail,
  },
});

// Define a route for sending emails
// Set up email options
const mailOptions = {
  from: userGmail,
  to: userGmail,
  subject: "Test Email 222",
  text: "This is a test email from Node.js!.",
};

// Send email
transporter.sendMail(mailOptions, (error, info) => {
  if (error) {
    console.log(error);
  }
  console.log("Email sent: " + info.response);
});

// Configuración de CORS
app.use(cors({
  origin: 'http://localhost:5173', // URL del frontend
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Métodos permitidos
  allowedHeaders: ['Content-Type', 'Authorization'], // Encabezados permitidos
}));

// Middleware para procesar JSON
app.use(express.json());

// Configuración de la base de datos
const DB = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "acopio",
});

DB.connect((err) => {
  if (err) {
    console.error("Error connecting to database:", err);
    return;
  }
  console.log("Conexión exitosa a la base de datos");
});

// Ruta para obtener usuarios
app.get("/api/acopio/usuarios", (req, res) => {
  const { correo } = req.query;

  const SQL_QUERY = correo
    ? "SELECT * FROM usuarios WHERE correo = ?"
    : "SELECT * FROM usuarios";

  DB.query(SQL_QUERY, [correo], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error al obtener los usuarios");
      return;
    }
    res.json(result);
  });
});

// Ruta para crear un nuevo usuario
// Ruta para crear un nuevo usuario y enviar correo de bienvenida
app.post("/api/acopio/usuarios", (req, res) => {
  console.log("Datos recibidos:", req.body);

  const { id, correo, contraseña, nombre, telefono, rol } = req.body;

  // Validar datos requeridos
  if (!id || !correo || !contraseña || !nombre || !telefono || !rol) {
    console.error("Faltan datos:", { id, correo, contraseña, nombre, telefono, rol });
    res.status(400).send("Faltan datos para registrar el usuario");
    return;
  }

  // Consulta SQL para insertar el usuario
  const SQL_QUERY = `
    INSERT INTO usuarios (id, correo, contraseña, nombre, telefono, rol)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  DB.query(SQL_QUERY, [id, correo, contraseña, nombre, telefono, rol], (err, result) => {
    if (err) {
      console.error("Error en la consulta SQL:", err);

      if (err.code === 'ER_DUP_ENTRY') {
        res.status(400).send("El correo ya está registrado.");
      } else {
        res.status(500).send("Error al crear el usuario");
      }
      return;
    }

    // Configurar las opciones del correo
    const mailOptions = {
      from: userGmail,
      to: correo, // Correo del destinatario
      subject: "Bienvenido a Acopio",
      text: `Hola ${nombre},\nGracias por registrarte en Acopio.  Tu contraseña de acceso es usuarioacopio`,
    };
    

    // Enviar correo al nuevo usuario
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Error al enviar el correo:", error);
        res.status(500).send("Usuario creado, pero no se pudo enviar el correo.");
        return;
      }
      console.log("Correo enviado: " + info.response);
      res.send("Usuario creado exitosamente y correo enviado.");
    });
  });
});


// Ruta para obtener todos los materiales
app.get("/api/acopio/materiales", (req, res) => {
  const SQL_QUERY = "SELECT * FROM materiales";
  DB.query(SQL_QUERY, (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error al obtener los materiales");
      return;
    }
    res.json(result);
  });
});

// Ruta para obtener un material específico por ID
app.get("/api/acopio/materiales/:id", (req, res) => {
  const { id } = req.params; // Obtener el ID de los parámetros de la solicitud

  const SQL_QUERY = "SELECT * FROM materiales WHERE id = ?";
  
  DB.query(SQL_QUERY, [id], (err, result) => {
    if (err) {
      console.error("Error al obtener el material:", err);
      res.status(500).send("Error al obtener el material");
      return;
    }

    if (result.length === 0) {
      res.status(404).send("Material no encontrado");
      return;
    }

    res.json(result[0]); // Enviar el primer resultado como objeto JSON
  });
});


// Ruta para crear un nuevo material
app.post("/api/acopio/materiales", (req, res) => {
  console.log("Datos recibidos para material:", req.body);

  // Desestructuración de los datos recibidos
  const { id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img } = req.body;

  // Validación de los datos necesarios
  if (!id || !nombre || !tipo || cantidad_disponible === undefined || !estado) {
    console.error("Faltan datos necesarios para registrar el material:", {
      id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img
    });
    return res.status(400).send("Faltan datos necesarios para registrar el material");
  }

  // Consulta SQL para insertar el nuevo material
  const SQL_QUERY = `
    INSERT INTO materiales (id, identificador, nombre, tipo, cantidad_disponible, estado, descripcion, color, img)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  DB.query(
    SQL_QUERY,
    [id, identificador || "", nombre, tipo, cantidad_disponible, estado, descripcion || "", color || "", img || ""],
    (err, result) => {
      if (err) {
        console.error("Error en la consulta SQL:", err);

        // Manejo de errores comunes
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).send("El ID del material ya está registrado.");
        }

        return res.status(500).send("Error al crear el material");
      }

      res.send("Material creado exitosamente");
    }
  );
});



// Ruta para obtener peticiones
app.get("/api/acopio/peticiones", (req, res) => {
  const SQL_QUERY = "SELECT * FROM peticiones";
  DB.query(SQL_QUERY, (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error al obtener las peticiones");
      return;
    }
    res.json(result);
  });
});

// Ejecución del servidor
app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
