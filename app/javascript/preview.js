const imagePreview = () => {
  if(document.getElementById('preview')) {
    const fileField = document.getElementById('file-field');
    const previewField = document.getElementById('preview-field');

    fileField.addEventListener('change', (e) => {
      const oldPreview = document.getElementById('preview');
      const previewClassName = oldPreview.className;
      const file = e.target.files[0];
      if (oldPreview && file) {
        oldPreview.remove();
      };
      const blob  = window.URL.createObjectURL(file);
      const previewImage = document.createElement('img');
      previewImage.setAttribute('id', 'preview');
      previewImage.setAttribute('class', previewClassName);
      previewImage.setAttribute('src', blob);
      previewField.prepend(previewImage);
    });
  };
};

document.addEventListener('DOMContentLoaded', () => {
  // console.log('event!');
  imagePreview();
});

document.addEventListener('turbo:load', () => {
  // console.log('turbo!');
  imagePreview();
});

document.addEventListener('turbo:frame-load', () => {
  // console.log('frame!');
  imagePreview();
});

document.addEventListener('turbo:render', () => {
  // console.log('frame!');
  imagePreview();
});
