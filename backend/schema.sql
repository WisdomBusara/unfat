-- Kaza database schema (Postgres)
-- Idempotent (IF NOT EXISTS everywhere) — safe to rerun, but it only ever
-- adds new tables/indexes, never alters existing ones. A column change
-- needs its own reviewed migration, not a rerun of this file.
-- Apply: psql -U kaza -d kaza -f schema.sql

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email                       TEXT UNIQUE NOT NULL,
    password_hash               TEXT NOT NULL,
    name                        TEXT NOT NULL,
    age                         INTEGER,
    sex                         TEXT DEFAULT 'other',
    height                      DOUBLE PRECISION,
    target_weight               DOUBLE PRECISION,
    activity_level              TEXT DEFAULT 'moderate',
    training_experience         TEXT DEFAULT 'beginner',
    goals                       JSONB DEFAULT '[]',
    preferred_activities        JSONB DEFAULT '[]',
    available_equipment         JSONB DEFAULT '[]',
    has_eating_disorder_history BOOLEAN DEFAULT FALSE,
    has_cardiovascular_issues   BOOLEAN DEFAULT FALSE,
    measurement_unit            TEXT DEFAULT 'metric',
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  TEXT NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    revoked     BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens(user_id);

CREATE TABLE IF NOT EXISTS weight_entries (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    weight                DOUBLE PRECISION NOT NULL,
    waist_circumference   DOUBLE PRECISION,
    body_fat_percentage   DOUBLE PRECISION,
    date                  TIMESTAMPTZ NOT NULL,
    notes                 TEXT DEFAULT '',
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_weight_entries_user_date ON weight_entries(user_id, date DESC);

CREATE TABLE IF NOT EXISTS workout_sessions (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date              TIMESTAMPTZ NOT NULL,
    workout_type      TEXT NOT NULL,
    exercises         JSONB NOT NULL DEFAULT '[]',
    sets              JSONB NOT NULL DEFAULT '[]',
    duration_minutes  INTEGER DEFAULT 0,
    calories_burned   INTEGER,
    notes             TEXT,
    rpe               DOUBLE PRECISION,
    completed         BOOLEAN DEFAULT TRUE,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_workout_sessions_user_date ON workout_sessions(user_id, date DESC);

CREATE TABLE IF NOT EXISTS goals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    goal_type       TEXT NOT NULL,
    target_weight   DOUBLE PRECISION,
    target_reps     INTEGER,
    target_distance DOUBLE PRECISION,
    start_date      TIMESTAMPTZ NOT NULL,
    target_date     TIMESTAMPTZ NOT NULL,
    priority        TEXT DEFAULT 'medium',
    strategies      JSONB DEFAULT '[]',
    notes           TEXT DEFAULT '',
    completed       BOOLEAN DEFAULT FALSE,
    completed_date  TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_goals_user_completed ON goals(user_id, completed);

CREATE TABLE IF NOT EXISTS meals (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    meal_type  TEXT NOT NULL,
    foods      JSONB NOT NULL DEFAULT '[]',
    date       TIMESTAMPTZ NOT NULL,
    notes      TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_meals_user_date ON meals(user_id, date DESC);

CREATE TABLE IF NOT EXISTS progress_photos (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    photo_url   TEXT NOT NULL,
    object_key  TEXT NOT NULL,
    angle       TEXT NOT NULL,
    date        TIMESTAMPTZ NOT NULL,
    weight      DOUBLE PRECISION,
    notes       TEXT DEFAULT '',
    ai_analysis JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_progress_photos_user_angle ON progress_photos(user_id, angle, date DESC);
