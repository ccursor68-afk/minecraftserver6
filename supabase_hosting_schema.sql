-- Hostings Table
CREATE TABLE IF NOT EXISTS hostings (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT,
    website TEXT,
    description TEXT,
    short_description TEXT,
    features TEXT[], -- Array of features
    min_price DECIMAL(10,2), -- Starting price
    max_price DECIMAL(10,2),
    currency TEXT DEFAULT 'TRY',
    
    -- Average ratings (calculated from reviews)
    avg_performance DECIMAL(3,2) DEFAULT 0, -- Lag/Performance rating
    avg_support DECIMAL(3,2) DEFAULT 0, -- Support speed rating
    avg_price_value DECIMAL(3,2) DEFAULT 0, -- Price/Performance rating
    avg_overall DECIMAL(3,2) DEFAULT 0, -- Overall average
    
    review_count INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hosting Reviews Table
CREATE TABLE IF NOT EXISTS hosting_reviews (
    id TEXT PRIMARY KEY,
    hosting_id TEXT NOT NULL REFERENCES hostings(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL,
    user_email TEXT,
    
    -- Individual ratings (1-5 stars)
    performance_rating INTEGER NOT NULL CHECK (performance_rating >= 1 AND performance_rating <= 5),
    support_rating INTEGER NOT NULL CHECK (support_rating >= 1 AND support_rating <= 5),
    price_value_rating INTEGER NOT NULL CHECK (price_value_rating >= 1 AND price_value_rating <= 5),
    
    -- Comment
    title TEXT,
    comment TEXT NOT NULL,
    
    -- Helpful votes
    helpful_count INTEGER DEFAULT 0,
    
    is_verified BOOLEAN DEFAULT false, -- Verified purchase
    is_approved BOOLEAN DEFAULT true, -- Admin approval
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_hostings_avg_overall ON hostings(avg_overall DESC);
CREATE INDEX IF NOT EXISTS idx_hostings_is_active ON hostings(is_active);
CREATE INDEX IF NOT EXISTS idx_hosting_reviews_hosting_id ON hosting_reviews(hosting_id);
CREATE INDEX IF NOT EXISTS idx_hosting_reviews_user_id ON hosting_reviews(user_id);

-- Function to update hosting ratings when a review is added/updated/deleted
CREATE OR REPLACE FUNCTION update_hosting_ratings()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        UPDATE hostings SET
            avg_performance = COALESCE((SELECT AVG(performance_rating) FROM hosting_reviews WHERE hosting_id = OLD.hosting_id AND is_approved = true), 0),
            avg_support = COALESCE((SELECT AVG(support_rating) FROM hosting_reviews WHERE hosting_id = OLD.hosting_id AND is_approved = true), 0),
            avg_price_value = COALESCE((SELECT AVG(price_value_rating) FROM hosting_reviews WHERE hosting_id = OLD.hosting_id AND is_approved = true), 0),
            avg_overall = COALESCE((SELECT AVG((performance_rating + support_rating + price_value_rating) / 3.0) FROM hosting_reviews WHERE hosting_id = OLD.hosting_id AND is_approved = true), 0),
            review_count = (SELECT COUNT(*) FROM hosting_reviews WHERE hosting_id = OLD.hosting_id AND is_approved = true),
            updated_at = NOW()
        WHERE id = OLD.hosting_id;
        RETURN OLD;
    ELSE
        UPDATE hostings SET
            avg_performance = COALESCE((SELECT AVG(performance_rating) FROM hosting_reviews WHERE hosting_id = NEW.hosting_id AND is_approved = true), 0),
            avg_support = COALESCE((SELECT AVG(support_rating) FROM hosting_reviews WHERE hosting_id = NEW.hosting_id AND is_approved = true), 0),
            avg_price_value = COALESCE((SELECT AVG(price_value_rating) FROM hosting_reviews WHERE hosting_id = NEW.hosting_id AND is_approved = true), 0),
            avg_overall = COALESCE((SELECT AVG((performance_rating + support_rating + price_value_rating) / 3.0) FROM hosting_reviews WHERE hosting_id = NEW.hosting_id AND is_approved = true), 0),
            review_count = (SELECT COUNT(*) FROM hosting_reviews WHERE hosting_id = NEW.hosting_id AND is_approved = true),
            updated_at = NOW()
        WHERE id = NEW.hosting_id;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger for auto-updating ratings
DROP TRIGGER IF EXISTS trigger_update_hosting_ratings ON hosting_reviews;
CREATE TRIGGER trigger_update_hosting_ratings
    AFTER INSERT OR UPDATE OR DELETE ON hosting_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_hosting_ratings();

-- RLS Policies
ALTER TABLE hostings ENABLE ROW LEVEL SECURITY;
ALTER TABLE hosting_reviews ENABLE ROW LEVEL SECURITY;

-- Hostings policies
CREATE POLICY "Anyone can view active hostings" ON hostings
    FOR SELECT USING (is_active = true);

CREATE POLICY "Admin can manage hostings" ON hostings
    FOR ALL USING (true);

-- Reviews policies
CREATE POLICY "Anyone can view approved reviews" ON hosting_reviews
    FOR SELECT USING (is_approved = true);

CREATE POLICY "Authenticated users can create reviews" ON hosting_reviews
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update their own reviews" ON hosting_reviews
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Admin can manage all reviews" ON hosting_reviews
    FOR ALL USING (true);

-- Insert some sample data
INSERT INTO hostings (id, name, logo_url, website, description, short_description, features, min_price, max_price, currency, is_featured) VALUES
('hosting_1', 'TurboHost', 'https://via.placeholder.com/100x100/22c55e/ffffff?text=TH', 'https://turbohost.com', 'Türkiye''nin en hızlı Minecraft hosting sağlayıcısı. DDoS koruması, SSD diskler ve 7/24 destek.', 'Hızlı ve güvenilir Minecraft sunucu hosting', ARRAY['DDoS Koruması', 'SSD Diskler', '7/24 Destek', 'Otomatik Yedekleme'], 49.99, 299.99, 'TRY', true),
('hosting_2', 'GameServer Pro', 'https://via.placeholder.com/100x100/3b82f6/ffffff?text=GS', 'https://gameserverpro.com', 'Profesyonel oyun sunucusu hosting. Düşük ping, yüksek performans.', 'Profesyonel oyun sunucu hosting', ARRAY['Düşük Ping', 'Mod Desteği', 'Panel Erişimi', 'Ücretsiz Kurulum'], 39.99, 249.99, 'TRY', true),
('hosting_3', 'CloudMC', 'https://via.placeholder.com/100x100/eab308/000000?text=CM', 'https://cloudmc.net', 'Bulut tabanlı Minecraft hosting. Ölçeklenebilir kaynaklar, esnek fiyatlandırma.', 'Bulut tabanlı esnek hosting', ARRAY['Bulut Altyapısı', 'Anlık Ölçekleme', 'API Erişimi', 'Docker Desteği'], 29.99, 199.99, 'TRY', false),
('hosting_4', 'MCHost Turkey', 'https://via.placeholder.com/100x100/ef4444/ffffff?text=MC', 'https://mchostturkey.com', 'Türkiye lokasyonlu Minecraft sunucu hosting. Yerli ve milli çözüm.', 'Türkiye lokasyonlu hosting', ARRAY['Türkiye Sunucuları', 'Türkçe Destek', 'Kolay Panel', 'Hızlı Kurulum'], 34.99, 179.99, 'TRY', false);
