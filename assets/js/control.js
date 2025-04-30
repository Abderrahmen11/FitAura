let firstName = document.getElementById("first-name");
let lastName = document.getElementById("last-name");
let email = document.getElementById("email");
let password = document.getElementById("password");
let confirmPassword = document.getElementById("confirm");

document.getElementById('show-signin').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('register-form').style.display = 'none';
    document.getElementById('signin-form').style.display = 'block';
    void document.getElementById('signin-form').offsetHeight;
});

document.getElementById('show-register').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('signin-form').style.display = 'none';
    document.getElementById('register-form').style.display = 'block';
    void document.getElementById('register-form').offsetHeight;
});


function validateRegister() {
    let isValid = true;

    // Reset styles and error messages
    const fields = [firstName, lastName, email, password, confirmPassword];
    const errorIds = ["first-name-error", "last-name-error", "email-error", "password-error", "confirm-error"];
    fields.forEach((field, index) => {
        field.style.border = "";
        document.getElementById(errorIds[index]).innerHTML = "";
    });

    // Validate First Name
    let firstNameValue = firstName.value.trim();
    if (firstNameValue === "") {
        firstName.style.border = "1px solid red";
        document.getElementById("first-name-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter your first name</p>";
        isValid = false;
    } else if (!/^[A-Za-z]+$/.test(firstNameValue)) {
        firstName.style.border = "1px solid red";
        document.getElementById("first-name-error").innerHTML = "<p style='color:red; font-size:13px'>First name must contain only letters</p>";
        isValid = false;
    } else if (/\s/.test(firstName.value)) { // original value, not trimmed
        firstName.style.border = "1px solid red";
        document.getElementById("first-name-error").innerHTML = "<p style='color:red; font-size:13px'>First name must not contain spaces</p>";
        isValid = false;
    }

    // Validate Last Name
    let lastNameValue = lastName.value.trim();
    if (lastNameValue === "") {
        lastName.style.border = "1px solid red";
        document.getElementById("last-name-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter your last name</p>";
        isValid = false;
    } else if (!/^[A-Za-z]+$/.test(lastNameValue)) {
        lastName.style.border = "1px solid red";
        document.getElementById("last-name-error").innerHTML = "<p style='color:red; font-size:13px'>Last name must contain only letters</p>";
        isValid = false;
    } else if (/\s/.test(lastName.value)) {
        lastName.style.border = "1px solid red";
        document.getElementById("last-name-error").innerHTML = "<p style='color:red; font-size:13px'>Last name must not contain spaces</p>";
        isValid = false;
    }




    // Validate Email
    let emailValue = email.value.trim();
    if (emailValue === "") {
        email.style.border = "1px solid red";
        document.getElementById("email-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter your email</p>";
        isValid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue)) {
        email.style.border = "1px solid red";
        document.getElementById("email-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter a valid email address</p>";
        isValid = false;
    }

    let passwordValue = password.value.trim();
    const symbolRegex = /[^a-zA-Z0-9_]/;

    if (passwordValue === "") {
        password.style.border = "1px solid red";
        document.getElementById("password-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter your password</p>";
        isValid = false;
    } else if (passwordValue.length < 8) {
        password.style.border = "1px solid red";
        document.getElementById("password-error").innerHTML = "<p style='color:red; font-size:13px'>Password must be at least 8 characters</p>";
        isValid = false;
    } else if (!/[a-z]/.test(passwordValue) || !/[A-Z]/.test(passwordValue) || !/[0-9]/.test(passwordValue) || !symbolRegex.test(passwordValue)) {
        password.style.border = "1px solid red";
        document.getElementById("password-error").innerHTML = "<p style='color:red; font-size:13px'>Password must contain at least one lowercase letter, one uppercase letter, one number, and one symbol (excluding _)</p>";
        isValid = false;
    }


    // Validate Confirm Password
    let confirmPasswordValue = confirmPassword.value.trim();
    if (confirmPasswordValue === "") {
        confirmPassword.style.border = "1px solid red";
        document.getElementById("confirm-error").innerHTML = "<p style='color:red; font-size:13px'>Please confirm your password</p>";
        isValid = false;
    } else if (confirmPasswordValue !== passwordValue) {
        confirmPassword.style.border = "1px solid red";
        document.getElementById("confirm-error").innerHTML = "<p style='color:red; font-size:13px'>Passwords do not match</p>";
        isValid = false;
    }

    return isValid;
}
function validateSignin() {
    let email = document.getElementById("signin-email");
    let password = document.getElementById("signin-password");
    let isValid = true;

    // Reset styles and error messages
    document.getElementById("signin-email-error").innerHTML = "";
    document.getElementById("signin-password-error").innerHTML = "";

    // Validate Email
    let emailValue = email.value.trim();
    if (emailValue === "") {
        email.style.border = "1px solid red";
        document.getElementById("signin-email-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter your email</p>";
        isValid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue)) {
        email.style.border = "1px solid red";
        document.getElementById("signin-email-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter a valid email address</p>";
        isValid = false;
    }

    // Validate Password
    let passwordValue = password.value.trim();
    if (passwordValue === "") {
        password.style.border = "1px solid red";
        document.getElementById("signin-password-error").innerHTML = "<p style='color:red; font-size:13px'>Please enter your password</p>";
        isValid = false;
    }

    if (isValid) {
        alert("Sign in successful! (This is a demo)");
    }

    return isValid;
}

class Member {
    #password;
    constructor(firstName, lastName, email, password) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.#password = password;
    }
    get firstName() {
        return this.firstName;
    }
    set firstName(value) {
        this.firstName = value;
    }
    get lastName() {
        return this.lastName;
    }
    set lastName(value) {
        this.lastName = value;
    }
    get email() {
        return this.email;
    }
    set email(value) {
        this.email = value;
    }
    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
    get password() {
        return this.#password;
    }
    set password(value) {
        this.#password = value;
    }
}
let Members = [];

const newMember = new Member(firstNameValue, lastNameValue, emailValue, passwordValue);
let addMember = (newMember) => {
    Members.push(newMember);
    console.log(Members);
    alert("Member added successfully!");
    console.log(Members);
    return true;
    return isValid;
}