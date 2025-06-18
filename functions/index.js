const functions = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");

admin.initializeApp();

exports.sendCredentialEmail = functions.onCall(
  {
    region: "us-central1",
    secrets: ["SENDGRID_API_KEY"],
  },
  async (data, context) => {
    try {
      sgMail.setApiKey(process.env.SENDGRID_API_KEY);

      const email = data?.data?.email;
      if (!email) {
        throw new functions.HttpsError(
          "invalid-argument",
          "Email is required but was not provided."
        );
      }

      const password = Math.random().toString(36).slice(-8);
      await admin.auth().createUser({ email, password });


      const msg = {
        to: email,
        from: {email:"noreply@em9760.shepherd.esstep.com",
              name: "Shepherd App Team"
        },
        subject: "Your Shepherd App Access",
        text: `Hello,\n\nEmail: ${email}\nPassword: ${password}\n\n\nBest regards, Shepherd App Team`,
      };

      await sgMail.send(msg);
      console.log(`Email sent to ${email}`);
      return { success: true };
    } catch (error) {
      console.error("Function error:", error);
      throw new functions.HttpsError("internal", error.message);
    }
  }
);
