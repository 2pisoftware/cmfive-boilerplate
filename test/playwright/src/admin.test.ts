import { test, expect } from '@playwright/test';
import { CmfiveHelper } from './helpers';

test('test admin page', async ({ page }) => {
    await CmfiveHelper.login(page, 'admin', 'admin');
    
});