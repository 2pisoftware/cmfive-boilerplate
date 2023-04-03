
const HOST = 'http://localhost:3500';

export class PlaywrightHelper {
    constructor(parameters) {
        
    }

    static async login(page, user, password) {
        await page.goto(HOST + '/auth/login');
        const input_login = page.locator('#login');
        await input_login.click();
        await input_login.fill(user);
        const input_password = page.locator('#password');
        await input_password.click();
        await input_password.fill(password);
        await page.getByRole('button', { name: 'Login' }).click();
    }
}
