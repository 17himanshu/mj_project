import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Create Supabase client
const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function setupDatabase() {
    try {
        // Read SQL files
        const schemaSQL = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');
        const initSQL = fs.readFileSync(path.join(__dirname, 'init.sql'), 'utf8');

        // Execute schema SQL
        console.log('Creating database schema...');
        const { error: schemaError } = await supabase.rpc('exec_sql', { sql: schemaSQL });
        if (schemaError) {
            throw new Error(`Schema creation failed: ${schemaError.message}`);
        }
        console.log('Schema created successfully!');

        // Execute initialization SQL
        console.log('Initializing database with basic data...');
        const { error: initError } = await supabase.rpc('exec_sql', { sql: initSQL });
        if (initError) {
            throw new Error(`Database initialization failed: ${initError.message}`);
        }
        console.log('Database initialized successfully!');

    } catch (error) {
        console.error('Error setting up database:', error);
        process.exit(1);
    }
}

setupDatabase(); 