



let screen = document.querySelector('#screen');
let btn = document.querySelectorAll('.btn');
for (item of btn) {
    item.addEventListener('click', (e) => {
        btntext = e.target.innerText;
        if (btntext == 'X') {
            btntext = '*';
        }
        else if (btntext == 'X^Y') {
            btntext = '^';
        }
        else if (btntext == 'X!') {
            btntext = "!";

        }
        // else if (screen.value == '=') {


        // }


        screen.value += btntext;
    })
}

function sin() {

    screen.value = Math.sin(eval(screen.value));
}
function cos() {
    screen.value = Math.cos(eval(screen.value));
}
function tan() {
    screen.value = Math.tan(eval(screen.value));
}
function pow() {
    screen.value = Math.pow(screen.value, 2);
}
function sqrt() {
    screen.value = Math.sqrt(eval(screen.value));
}
function log() {
    screen.value = Math.log(eval(screen.value));
}
function pi() {
    screen.value = Math.PI;
}
function e() {
    screen.value = Math.E;
}
function fact() {
    let i, num, f = 1;
    num = eval(screen.value);

    if (num == '0') {
        f = 1;
    }
    else {
        for (i = 1; i <= num; i++) {
            f = f * i;
        }
        screen.value = f;

    }
}
function del() {
    screen.value = screen.value.substr(0, screen.value.length - 1);
}
function evalute() {
    try {
        screen.value = eval(screen.value);
    }
    catch (err) {
        alert("invalid  data !!");
    }
}