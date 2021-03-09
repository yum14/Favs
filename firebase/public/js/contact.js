'use strict';

document.addEventListener('DOMContentLoaded', () => {

  const displayStatus = (status) => {
    switch (status) {
      case 'success':
        document.querySelector('.sendmail-status').classList.remove('error-status');
        document.querySelector('.sendmail-status').classList.add('success-status');
        document.querySelector('.sendmail-status').textContent = 'お問い合わせありがとうございます。メッセージは送信されました。';
        document.querySelector('.sendmail-status-box').classList.remove('hidden');
        break;
      case 'error':
        document.querySelector('.sendmail-status').classList.remove('success-status');
        document.querySelector('.sendmail-status').classList.add('error-status');
        document.querySelector('.sendmail-status').textContent = '送信に失敗しました。再度お試しください。';
        document.querySelector('.sendmail-status-box').classList.remove('hidden');
        break;

      default:
        break;
    }
  }

  document.querySelector('#submit').addEventListener('click', (event) => {

    const nameTag = document.querySelector('#name');
    const emailTag = document.querySelector('#email');
    const titleTag = document.querySelector('#title');
    const messageTag = document.querySelector('#message');
    const submitTag = document.querySelector('#submit');

    document.querySelector('#name-validation-error').classList.add('hidden');
    document.querySelector('#email-validation-error1').classList.add('hidden');
    document.querySelector('#email-validation-error2').classList.add('hidden');

    if (!nameTag.value || !emailTag.value || (emailTag.value && !emailTag.checkValidity())) {
      if (!nameTag.value) {
        document.querySelector('#name-validation-error').classList.remove('hidden');
      }
      if (!emailTag.value) {
        document.querySelector('#email-validation-error1').classList.remove('hidden');
      }
      if (emailTag.value && !emailTag.checkValidity()) {
        document.querySelector('#email-validation-error2').classList.remove('hidden');
      }
      return;
    }
    
    submitTag.disabled = true;
    const position = submitTag.getBoundingClientRect();
    window.scrollTo(0, position.top);

    fetch('https://us-central1-favs-22518.cloudfunctions.net/sendMail', {
      method: 'post',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        data: {
          name: nameTag.value,
          email: emailTag.value,
          title: titleTag.value,
          message: messageTag.value
        }
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(response.message);
      }

      nameTag.value = '';
      emailTag.value = '';
      titleTag.value = '';
      messageTag.value = '';

      displayStatus('success');
    })
    .catch(reason => {
      displayStatus('error');
      submitTag.disabled = false;
    });
  });
});
    
