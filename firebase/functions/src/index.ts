import * as functions from 'firebase-functions';
import * as nodemailer from 'nodemailer';
import * as admin from 'firebase-admin';

admin.initializeApp();

const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;
const adminEmail = functions.config().admin.email;

// 送信に使用するメールサーバーの設定
let transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
      user: gmailEmail,
      pass: gmailPassword
  }
});


const createContent = (data: any) => {
  return `以下の内容でお問い合わせを受けました。
  
  お名前:
  ${data.name}
  
  メールアドレス:
  ${data.email}
  
  題名:
  ${data.title}

  本文:
  ${data.message}
  `;
};


exports.sendMail = functions.https.onCall(async (data, context) => {
  // メール設定
  let mailOptions = {
    from: gmailEmail,
    to: adminEmail,
    subject: "【favs】お問い合わせ",
    text: createContent(data),
  };
  

  functions.logger.info(`from: ${mailOptions.from}, to: ${mailOptions.to}, subject: ${mailOptions.subject}, text: ${mailOptions.text}`);

  // 管理者へのメール送信
  try {
    transporter.sendMail(mailOptions, (err: Error | null, info: any) => {
      if (err) {
        functions.logger.warn(err.message);
      } else {
        functions.logger.info(`メール送信に成功`);
      }
    });
  } catch (e) {
    functions.logger.warn(`send failed. ${e}`);
    throw new functions.https.HttpsError('internal', 'send failed');
  }
});
