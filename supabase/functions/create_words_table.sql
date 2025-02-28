CREATE TABLE words (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    word TEXT NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE words ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all users to read words"
ON words
FOR SELECT
USING (true);

CREATE POLICY "Allow authenticated users to insert words"
ON words
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow users to update their own words"
ON words
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Allow users to delete their own words"
ON words
FOR DELETE
USING (auth.uid() = user_id);
