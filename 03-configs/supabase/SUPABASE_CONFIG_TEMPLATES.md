# Supabase Configuration Templates - Advanced RLS Policies

Tämä dokumentti sisältää edistyneet Supabase-konfiguraatiot ja RLS (Row Level Security) -käytännöt, jotka on standardoitu kaikille projekteille. Nämä mallit varmistavat tietoturvan, suorituskyvyn ja skaalautuvuuden.

---

# Perusarkkitehtuuri

## Database Schema Standard

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enums for consistent data types
CREATE TYPE "user_role" AS ENUM ('admin', 'user', 'moderator');
CREATE TYPE "subscription_status" AS ENUM ('active', 'inactive', 'cancelled', 'trial');
CREATE TYPE "content_status" AS ENUM ('draft', 'published', 'archived');

-- Standard user profile table
CREATE TABLE "profiles" (
  "id" TEXT NOT NULL,
  "email" TEXT NOT NULL,
  "full_name" TEXT,
  "avatar_url" TEXT,
  "role" "user_role" NOT NULL DEFAULT 'user',
  "subscription_status" "subscription_status" NOT NULL DEFAULT 'trial',
  "metadata" JSONB DEFAULT '{}',
  "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "profiles_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "profiles_email_key" UNIQUE ("email")
);

-- Audit log table for tracking changes
CREATE TABLE "audit_logs" (
  "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" TEXT,
  "table_name" TEXT NOT NULL,
  "record_id" TEXT NOT NULL,
  "action" TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
  "old_values" JSONB,
  "new_values" JSONB,
  "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- Enable RLS on all tables
ALTER TABLE "profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "audit_logs" ENABLE ROW LEVEL SECURITY;
```

## Advanced RLS Policies

### User Profile Policies

```sql
-- Users can view their own profile
CREATE POLICY "Users can view own profile" ON "profiles"
  FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile (except role and subscription)
CREATE POLICY "Users can update own profile" ON "profiles"
  FOR UPDATE USING (
    auth.uid() = id AND 
    NOT (role, subscription_status) IS DISTINCT FROM (EXCLUDED.role, EXCLUDED.subscription_status)
  );

-- Users can insert their own profile (on signup)
CREATE POLICY "Users can insert own profile" ON "profiles"
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles" ON "profiles"
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM "profiles" 
      WHERE "id" = auth.uid() AND "role" = 'admin'
    )
  );

-- Admins can update all profiles
CREATE POLICY "Admins can update all profiles" ON "profiles"
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM "profiles" 
      WHERE "id" = auth.uid() AND "role" = 'admin'
    )
  );
```

### Audit Log Policies

```sql
-- Users can view their own audit logs
CREATE POLICY "Users can view own audit logs" ON "audit_logs"
  FOR SELECT USING (auth.uid() = user_id);

-- Admins can view all audit logs
CREATE POLICY "Admins can view all audit logs" ON "audit_logs"
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM "profiles" 
      WHERE "id" = auth.uid() AND "role" = 'admin'
    )
  );

-- System can insert audit logs (via triggers)
CREATE POLICY "System can insert audit logs" ON "audit_logs"
  FOR INSERT WITH CHECK (true);
```

---

# Trigger Functions for Audit Trail

## Automatic Audit Logging

```sql
-- Function to create audit log entries
CREATE OR REPLACE FUNCTION public.audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO public.audit_logs (user_id, table_name, record_id, action, old_values)
    VALUES (
      COALESCE(auth.uid(), 'system'),
      TG_TABLE_NAME,
      OLD.id,
      'DELETE',
      to_jsonb(OLD)
    );
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO public.audit_logs (user_id, table_name, record_id, action, old_values, new_values)
    VALUES (
      COALESCE(auth.uid(), 'system'),
      TG_TABLE_NAME,
      NEW.id,
      'UPDATE',
      to_jsonb(OLD),
      to_jsonb(NEW)
    );
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    INSERT INTO public.audit_logs (user_id, table_name, record_id, action, new_values)
    VALUES (
      COALESCE(auth.uid(), 'system'),
      TG_TABLE_NAME,
      NEW.id,
      'INSERT',
      to_jsonb(NEW)
    );
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers for all tables
CREATE TRIGGER audit_profiles_trigger
  AFTER INSERT OR UPDATE OR DELETE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();
```

## Automatic Timestamp Updates

```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for timestamp updates
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
```

---

# Advanced Database Functions

## User Management Functions

```sql
-- Function to promote user to admin
CREATE OR REPLACE FUNCTION public.promote_to_admin(target_user_id TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  -- Only admins can promote other users
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  ) THEN
    RAISE EXCEPTION 'Only admins can promote users';
  END IF;

  UPDATE public.profiles 
  SET role = 'admin', updated_at = CURRENT_TIMESTAMP
  WHERE id = target_user_id;

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update subscription status
CREATE OR REPLACE FUNCTION public.update_subscription(
  target_user_id TEXT,
  new_status "subscription_status"
)
RETURNS BOOLEAN AS $$
BEGIN
  -- Users can update their own subscription, admins can update any
  IF auth.uid() != target_user_id AND NOT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  ) THEN
    RAISE EXCEPTION 'Permission denied';
  END IF;

  UPDATE public.profiles 
  SET subscription_status = new_status, updated_at = CURRENT_TIMESTAMP
  WHERE id = target_user_id;

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

## Data Analytics Functions

```sql
-- Function to get user statistics (admin only)
CREATE OR REPLACE FUNCTION public.get_user_statistics()
RETURNS TABLE (
  total_users BIGINT,
  active_subscriptions BIGINT,
  trial_users BIGINT,
  admin_count BIGINT
) AS $$
BEGIN
  -- Only admins can access statistics
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  ) THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;

  RETURN QUERY
  SELECT 
    COUNT(*) as total_users,
    COUNT(*) FILTER (WHERE subscription_status = 'active') as active_subscriptions,
    COUNT(*) FILTER (WHERE subscription_status = 'trial') as trial_users,
    COUNT(*) FILTER (WHERE role = 'admin') as admin_count
  FROM public.profiles;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user activity timeline
CREATE OR REPLACE FUNCTION public.get_user_activity(
  user_id TEXT,
  days_back INTEGER DEFAULT 30
)
RETURNS TABLE (
  action_date TIMESTAMP WITH TIME ZONE,
  table_name TEXT,
  action TEXT,
  details JSONB
) AS $$
BEGIN
  -- Users can view their own activity, admins can view any
  IF auth.uid() != user_id AND NOT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  ) THEN
    RAISE EXCEPTION 'Permission denied';
  END IF;

  RETURN QUERY
  SELECT 
    created_at as action_date,
    table_name,
    action,
    COALESCE(new_values, old_values) as details
  FROM public.audit_logs
  WHERE user_id = get_user_activity.user_id
    AND created_at >= CURRENT_TIMESTAMP - INTERVAL '1 day' * days_back
  ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

# Performance Optimization

## Indexes for Performance

```sql
-- Essential indexes for user queries
CREATE INDEX "profiles_id_idx" ON "profiles"("id");
CREATE INDEX "profiles_email_idx" ON "profiles"("email");
CREATE INDEX "profiles_role_idx" ON "profiles"("role");
CREATE INDEX "profiles_subscription_status_idx" ON "profiles"("subscription_status");
CREATE INDEX "profiles_created_at_idx" ON "profiles"("created_at");

-- Composite indexes for common queries
CREATE INDEX "profiles_role_subscription_idx" ON "profiles"("role", "subscription_status");
CREATE INDEX "profiles_subscription_created_idx" ON "profiles"("subscription_status", "created_at");

-- Audit log indexes
CREATE INDEX "audit_logs_user_id_idx" ON "audit_logs"("user_id");
CREATE INDEX "audit_logs_table_name_idx" ON "audit_logs"("table_name");
CREATE INDEX "audit_logs_created_at_idx" ON "audit_logs"("created_at");
CREATE INDEX "audit_logs_user_action_idx" ON "audit_logs"("user_id", "action", "created_at");

-- Full-text search indexes
CREATE INDEX "profiles_full_name_fts_idx" ON "profiles" USING gin(to_tsvector('english', full_name));
CREATE INDEX "profiles_email_fts_idx" ON "profiles" USING gin(to_tsvector('english', email));
```

## Partitioning for Large Tables

```sql
-- Partition audit logs by month for better performance
CREATE TABLE "audit_logs_partitioned" (
  LIKE "audit_logs" INCLUDING ALL
) PARTITION BY RANGE (created_at);

-- Create monthly partitions
CREATE TABLE "audit_logs_2024_01" PARTITION OF "audit_logs_partitioned"
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE "audit_logs_2024_02" PARTITION OF "audit_logs_partitioned"
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Function to create new partitions automatically
CREATE OR REPLACE FUNCTION public.create_monthly_partition(table_name TEXT, start_date DATE)
RETURNS VOID AS $$
DECLARE
  partition_name TEXT;
  end_date DATE;
BEGIN
  partition_name := table_name || '_' || to_char(start_date, 'YYYY_MM');
  end_date := start_date + INTERVAL '1 month';
  
  EXECUTE format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES FROM (%L) TO (%L)',
                 partition_name, table_name, start_date, end_date);
END;
$$ LANGUAGE plpgsql;
```

---

# Security Best Practices

## Secure Function Definitions

```sql
-- Function to check if user has specific role
CREATE OR REPLACE FUNCTION public.has_role(required_role "user_role")
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = required_role
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user can access resource
CREATE OR REPLACE FUNCTION public.can_access_resource(resource_owner_id TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  -- Users can access their own resources
  IF auth.uid() = resource_owner_id THEN
    RETURN true;
  END IF;
  
  -- Admins can access all resources
  IF public.has_role('admin') THEN
    RETURN true;
  END IF;
  
  RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to sanitize user input
CREATE OR REPLACE FUNCTION public.sanitize_email(email TEXT)
RETURNS TEXT AS $$
BEGIN
  -- Basic email validation and sanitization
  IF email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
    RAISE EXCEPTION 'Invalid email format';
  END IF;
  
  RETURN lower(trim(email));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

## Rate Limiting

```sql
-- Table for rate limiting
CREATE TABLE "rate_limits" (
  "id" TEXT NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" TEXT NOT NULL,
  "action_type" TEXT NOT NULL,
  "count" INTEGER NOT NULL DEFAULT 1,
  "window_start" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "rate_limits_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "rate_limits_user_action_idx" ON "rate_limits"("user_id", "action_type", "window_start");

-- Function to check rate limit
CREATE OR REPLACE FUNCTION public.check_rate_limit(
  action_type TEXT,
  max_requests INTEGER DEFAULT 100,
  window_minutes INTEGER DEFAULT 60
)
RETURNS BOOLEAN AS $$
DECLARE
  current_count INTEGER;
  window_start TIMESTAMP WITH TIME ZONE;
BEGIN
  window_start := CURRENT_TIMESTAMP - INTERVAL '1 minute' * window_minutes;
  
  -- Get current count
  SELECT COALESCE(SUM(count), 0) INTO current_count
  FROM public.rate_limits
  WHERE user_id = auth.uid()
    AND action_type = check_rate_limit.action_type
    AND window_start >= window_start;
  
  -- Check if limit exceeded
  IF current_count >= max_requests THEN
    RETURN false;
  END IF;
  
  -- Update or insert rate limit record
  INSERT INTO public.rate_limits (user_id, action_type, count, window_start)
  VALUES (auth.uid(), action_type, 1, CURRENT_TIMESTAMP)
  ON CONFLICT (user_id, action_type, window_start) 
  DO UPDATE SET count = rate_limits.count + 1;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

# Backup and Recovery

## Automated Backup Functions

```sql
-- Function to create table backup
CREATE OR REPLACE FUNCTION public.backup_table(
  table_name TEXT,
  backup_suffix TEXT DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
  backup_table_name TEXT;
  sql TEXT;
BEGIN
  backup_suffix := COALESCE(backup_suffix, to_char(CURRENT_TIMESTAMP, 'YYYY_MM_DD_HH24_MI_SS'));
  backup_table_name := table_name || '_backup_' || backup_suffix;
  
  sql := format('CREATE TABLE %I AS SELECT * FROM %I', backup_table_name, table_name);
  EXECUTE sql;
  
  RETURN backup_table_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to restore from backup
CREATE OR REPLACE FUNCTION public.restore_from_backup(
  original_table TEXT,
  backup_table TEXT
)
RETURNS BOOLEAN AS $$
BEGIN
  -- Only admins can restore from backup
  IF NOT public.has_role('admin') THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;
  
  EXECUTE format('TRUNCATE TABLE %I', original_table);
  EXECUTE format('INSERT INTO %I SELECT * FROM %I', original_table, backup_table);
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

# Monitoring and Health Checks

## Database Health Functions

```sql
-- Function to get database health metrics
CREATE OR REPLACE FUNCTION public.get_database_health()
RETURNS TABLE (
  metric_name TEXT,
  metric_value NUMERIC,
  status TEXT
) AS $$
BEGIN
  -- Only admins can access health metrics
  IF NOT public.has_role('admin') THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;
  
  RETURN QUERY
  SELECT 'total_connections'::TEXT, COUNT(*)::NUMERIC, 
         CASE WHEN COUNT(*) < 100 THEN 'good' ELSE 'warning' END::TEXT
  FROM pg_stat_activity;
  
  RETURN QUERY
  SELECT 'database_size_mb'::TEXT, 
         (pg_database_size(current_database()) / 1024 / 1024)::NUMERIC,
         CASE WHEN pg_database_size(current_database()) < 1024*1024*1024 THEN 'good' ELSE 'warning' END::TEXT;
  
  RETURN QUERY
  SELECT 'active_users_today'::TEXT, COUNT(*)::NUMERIC, 'good'::TEXT
  FROM public.profiles
  WHERE updated_at >= CURRENT_DATE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check table sizes
CREATE OR REPLACE FUNCTION public.get_table_sizes()
RETURNS TABLE (
  table_name TEXT,
  size_mb NUMERIC,
  row_count BIGINT
) AS $$
BEGIN
  IF NOT public.has_role('admin') THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;
  
  RETURN QUERY
  SELECT 
    schemaname||'.'||tablename as table_name,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size_mb,
    n_tup_ins + n_tup_upd + n_tup_del as row_count
  FROM pg_stat_user_tables
  ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

# TypeScript Types

## Generated Types

```typescript
// src/types/supabase.ts
export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string;
          full_name: string | null;
          avatar_url: string | null;
          role: 'admin' | 'user' | 'moderator';
          subscription_status: 'active' | 'inactive' | 'cancelled' | 'trial';
          metadata: Record<string, any>;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          email: string;
          full_name?: string | null;
          avatar_url?: string | null;
          role?: 'admin' | 'user' | 'moderator';
          subscription_status?: 'active' | 'inactive' | 'cancelled' | 'trial';
          metadata?: Record<string, any>;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          full_name?: string | null;
          avatar_url?: string | null;
          role?: 'admin' | 'user' | 'moderator';
          subscription_status?: 'active' | 'inactive' | 'cancelled' | 'trial';
          metadata?: Record<string, any>;
          updated_at?: string;
        };
      };
      audit_logs: {
        Row: {
          id: string;
          user_id: string | null;
          table_name: string;
          record_id: string;
          action: string;
          old_values: Record<string, any> | null;
          new_values: Record<string, any> | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id?: string | null;
          table_name: string;
          record_id: string;
          action: string;
          old_values?: Record<string, any> | null;
          new_values?: Record<string, any> | null;
          created_at?: string;
        };
      };
    };
    Functions: {
      promote_to_admin: {
        Args: {
          target_user_id: string;
        };
        Returns: boolean;
      };
      update_subscription: {
        Args: {
          target_user_id: string;
          new_status: 'active' | 'inactive' | 'cancelled' | 'trial';
        };
        Returns: boolean;
      };
      get_user_statistics: {
        Args: Record<PropertyKey, never>;
        Returns: {
          total_users: number;
          active_subscriptions: number;
          trial_users: number;
          admin_count: number;
        };
      };
    };
  };
};
```

---

# Client-side Utilities

## Supabase Client Configuration

```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js';
import { Database } from '@/types/supabase';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
  },
  realtime: {
    params: {
      eventsPerSecond: 10,
    },
  },
});

// Admin client for server-side operations
export const supabaseAdmin = createClient<Database>(
  supabaseUrl,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
);
```

## Custom Hooks

```typescript
// src/hooks/use-supabase-admin.ts
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/lib/supabase';
import { Database } from '@/types/supabase';

type Profile = Database['public']['Tables']['profiles']['Row'];

export function useProfile(userId: string) {
  return useQuery({
    queryKey: ['profile', userId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();
      
      if (error) throw error;
      return data;
    },
    enabled: !!userId,
  });
}

export function useUpdateProfile() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async ({ 
      userId, 
      updates 
    }: { 
      userId: string; 
      updates: Partial<Profile> 
    }) => {
      const { data, error } = await supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();
      
      if (error) throw error;
      return data;
    },
    onSuccess: (data, variables) => {
      queryClient.invalidateQueries({ queryKey: ['profile', variables.userId] });
    },
  });
}

export function usePromoteToAdmin() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (targetUserId: string) => {
      const { data, error } = await supabase.rpc('promote_to_admin', {
        target_user_id: targetUserId,
      });
      
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profiles'] });
    },
  });
}
```

---

# Tämä Supabase-konfiguraatio takaa:

1. **Tietoturva** - Kattavat RLS-käytännöt ja audit-loki
2. **Suorituskyky** - Optimoidut indeksit ja partitiointi
3. **Skaalautuvuus** - Automatisoidut backupit ja monitorointi
4. **Ylläpidettävyys** - Standardoidut funktiot ja tyypit
5. **Vikasietoisuus** - Rate limiting ja virheenkäsittely
6. **Auditointi** - Täydellinen muutosloki kaikille toiminnoille

**Muista:** Päivitä nämä konfiguraatiot säännöllisesti ja testaa ne huolellisesti ennen tuotantokäyttöä.
