const nodemailer = require("nodemailer");

const mailer = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: 587,
  secure: false,
  auth: {
    user: process.env.SMTP_ADDRESS,
    pass: process.env.SMTP_PASSWORD,
  },
});


async function sendAuthCode(emailAddress, code, lang){
    switch(lang){
        case "en":
            const info = await mailer.sendMail({
                from: `"KeskonMange 🍽️" <${process.env.SMTP_ADDRESS}>`,
                to: `${emailAddress}, ${emailAddress}`,
                subject: "Verification code",
                text: `Welcome back! Here is your code: ${code}\nHave a nice day!\nKeskonMange team.`,
                html: `<b>Welcome back! Here is your code: ${code}<br>Have a nice day!<br>KeskonMange team.</b>`,
              });
            return info.response;
        case "debug":
          const debugMail = await mailer.sendMail({
              from: `"KeskonMange TEST_SESSION" <${process.env.SMTP_ADDRESS}>`,
              to: `${emailAddress}, ${emailAddress}`,
              subject: `${code}`,
            });
          return debugMail.response;
        default:
            return sendAuthCode(emailAddress, code, "en");
    }

}

async function sendVerificationCode(emailAddress, username, code, lang) {
    switch(lang){
        case "en":
            const info = await mailer.sendMail({
                from: `"KeskonMange 🍽️" <${process.env.SMTP_ADDRESS}>`,
                to: `${emailAddress}, ${emailAddress}`,
                subject: `Welcome ${username}, Just one more step!`,
                html: `<b>Welcome in KeskonMange family ${username}!<br> In order to know you better enter this code: ${code} in the app!<br>
                We promise you, that's the last step...
                <br>KeskonMange team.</b>`,
              });
            return info.response;
        default:
            return sendAuthCode(emailAddress, "en");
    }
}

module.exports = {
    sendAuthCode : sendAuthCode,
    sendVerificationCode : sendVerificationCode
};