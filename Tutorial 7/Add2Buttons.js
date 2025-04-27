let isRightAligned = false;
let isColorChanged = false;
const originalColor = "rgb(30, 202, 21)";
const newColor = "rgb(128, 0, 128)";

function toggleTextAlignment() {
    const cards = document.querySelectorAll(".card");
    isRightAligned = !isRightAligned;
    cards.forEach(card => {
        card.style.textAlign = isRightAligned ? "right" : "center";
    });
}

function toggleCardColor() {
    const card = document.querySelectorAll(".card")[0];
    if (!isColorChanged) {
        card.style.backgroundColor = newColor;
    } else {
        card.style.backgroundColor = originalColor;
    }
    isColorChanged = !isColorChanged;
}