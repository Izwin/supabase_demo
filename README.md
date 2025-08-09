# Coffee Tracker

A Flutter app to track your coffee consumption and expenses using Supabase for backend services.

### Setup

#### 1. Clone the repository

```bash
git clone https://github.com/Izwin/supabase_demo
cd coffee_tracker
```

#### 2. Install dependencies

```bash
flutter pub get
```

#### 3. Create a Supabase project

1. Go to [Supabase](https://supabase.com/) and create a new project
2. Note your project URL and anon/public key

#### 4. Set up the database

1. In your Supabase project, go to the SQL Editor
2. Run the following SQL to create the necessary table:

```sql
-- Create coffee_logs table
CREATE TABLE coffee_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  price DECIMAL(10, 2) NOT NULL
);

-- Set up Row Level Security
ALTER TABLE coffee_logs ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to see only their own logs
CREATE POLICY "Users can view their own coffee logs" 
  ON coffee_logs 
  FOR SELECT 
  USING (auth.uid() = user_id);

-- Create policy to allow users to insert their own logs
CREATE POLICY "Users can insert their own coffee logs" 
  ON coffee_logs 
  FOR INSERT 
  WITH CHECK (auth.uid() = user_id);
```

#### 5. Set up environment variables

1. Create a `.env` file in the root of your project
2. Add your Supabase credentials:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

Replace `your_supabase_url` and `your_supabase_anon_key` with the values from your Supabase project dashboard.

#### 6. Run the app

```bash
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
