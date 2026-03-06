import React from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity, Dimensions } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS } from '../../utils/constants';

const { width, height } = Dimensions.get('window');

const WelcomeScreen = ({ navigation }) => {
  const handleGetStarted = () => {
    navigation.navigate('Login');
  };

  return (
    <View style={styles.container}>
      {/* Background Decorative Elements */}
      <View style={styles.backgroundGlow}>
        <View style={[styles.glow, styles.topGlow]} />
        <View style={[styles.glow, styles.bottomGlow]} />
      </View>

      {/* Main Content */}
      <View style={styles.content}>
        {/* Logo Section */}
        <View style={styles.logoSection}>
          <View style={styles.logoContainer}>
            <View style={styles.iconBox}>
              <MaterialIcons name="school" size={28} color={COLORS.backgroundDark} />
            </View>
            <Text style={styles.logoText}>Studier</Text>
          </View>
          <Text style={styles.tagline}>Connect. Learn. Excel.</Text>
        </View>

        {/* Illustration Area */}
        <View style={styles.illustrationArea}>
          <View style={styles.imageContainer}>
            {/* Abstract background shape */}
            <View style={styles.abstractShape} />
            
            {/* Main Image */}
            <View style={styles.imageCard}>
<Image
                source={{ uri: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800' }}
                style={styles.image}
                resizeMode="cover"
              />
              
              {/* Gradient Overlay */}
              <LinearGradient
                colors={['transparent', 'rgba(16, 34, 22, 0.8)']}
                style={styles.imageOverlay}
              />

              {/* Floating Badge */}
              <View style={styles.floatingBadge}>
                <View style={styles.badge}>
                  <View style={styles.badgeIcon}>
                    <MaterialIcons name="verified" size={24} color={COLORS.primary} />
                  </View>
                  <View style={styles.badgeText}>
                    <Text style={styles.badgeTitle}>EXPERT TUTORS</Text>
                    <Text style={styles.badgeSubtitle}>Verified students from your university.</Text>
                  </View>
                </View>
              </View>
            </View>
          </View>
        </View>

        {/* Action Area */}
        <View style={styles.actionArea}>
          <View style={styles.headlineContainer}>
            <Text style={styles.headline}>
              Master your courses{'\n'}with peer support
            </Text>
            <Text style={styles.subtitle}>
              Find the perfect tutor for any subject, right on campus. Safe, simple, and effective.
            </Text>
          </View>

          <TouchableOpacity 
            style={styles.primaryButton} 
            onPress={handleGetStarted}
            activeOpacity={0.8}
          >
            <Text style={styles.buttonText}>Get Started</Text>
            <MaterialIcons name="arrow-forward" size={20} color={COLORS.backgroundDark} />
          </TouchableOpacity>

          <TouchableOpacity onPress={() => navigation.navigate('Login')}>
            <Text style={styles.loginLink}>Already have an account? <Text style={styles.loginLinkBold}>Log in</Text></Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.backgroundDark,
  },
  backgroundGlow: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    overflow: 'hidden',
  },
  glow: {
    position: 'absolute',
    borderRadius: 999,
    opacity: 0.1,
  },
  topGlow: {
    width: 384,
    height: 384,
    backgroundColor: COLORS.primary,
    top: -128,
    left: -128,
  },
  bottomGlow: {
    width: 320,
    height: 320,
    backgroundColor: COLORS.primary,
    bottom: -80,
    right: -80,
    opacity: 0.05,
  },
  content: {
    flex: 1,
    paddingHorizontal: 24,
    paddingTop: 48,
    paddingBottom: 32,
    justifyContent: 'space-between',
  },
  logoSection: {
    alignItems: 'center',
    marginTop: 16,
  },
  logoContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  iconBox: {
    width: 40,
    height: 40,
    backgroundColor: COLORS.primary,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 8,
    shadowColor: COLORS.primary,
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.4,
    shadowRadius: 15,
    elevation: 8,
  },
  logoText: {
    fontSize: 28,
    fontWeight: 'bold',
    color: COLORS.white,
    letterSpacing: -0.5,
  },
  tagline: {
    fontSize: 13,
    color: COLORS.gray[400],
    letterSpacing: 1,
    fontWeight: '300',
  },
  illustrationArea: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 32,
  },
  imageContainer: {
    width: '100%',
    aspectRatio: 0.8,
    maxHeight: height * 0.5,
    position: 'relative',
  },
  abstractShape: {
    position: 'absolute',
    top: 48,
    left: 32,
    right: 32,
    bottom: 48,
    backgroundColor: 'rgba(148, 163, 184, 0.15)',
    borderRadius: 16,
    transform: [{ rotate: '-6deg' }, { scale: 0.95 }],
    borderWidth: 1,
    borderColor: 'rgba(148, 163, 184, 0.2)',
  },
  imageCard: {
    flex: 1,
    borderRadius: 16,
    overflow: 'hidden',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.3,
    shadowRadius: 20,
    elevation: 10,
    borderWidth: 1,
    borderColor: COLORS.gray[800],
  },
  image: {
    width: '100%',
    height: '100%',
    opacity: 0.9,
  },
  imageOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: '60%',
  },
  floatingBadge: {
    position: 'absolute',
    bottom: 24,
    left: 24,
    right: 24,
  },
  badge: {
    backgroundColor: 'rgba(16, 34, 22, 0.8)',
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    borderWidth: 1,
    borderColor: COLORS.gray[700],
  },
  badgeIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(19, 236, 91, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  badgeText: {
    flex: 1,
  },
  badgeTitle: {
    fontSize: 11,
    color: COLORS.primary,
    fontWeight: '600',
    letterSpacing: 1.2,
    marginBottom: 2,
  },
  badgeSubtitle: {
    fontSize: 13,
    color: COLORS.white,
    fontWeight: '300',
  },
  actionArea: {
    gap: 16,
  },
  headlineContainer: {
    alignItems: 'center',
    marginBottom: 16,
  },
  headline: {
    fontSize: 26,
    fontWeight: '600',
    color: COLORS.white,
    textAlign: 'center',
    lineHeight: 34,
    marginBottom: 12,
  },
  subtitle: {
    fontSize: 14,
    color: COLORS.gray[400],
    textAlign: 'center',
    lineHeight: 20,
    paddingHorizontal: 16,
  },
  primaryButton: {
    backgroundColor: COLORS.primary,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 12,
    shadowColor: COLORS.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.25,
    shadowRadius: 20,
    elevation: 8,
    gap: 8,
  },
  buttonText: {
    color: COLORS.backgroundDark,
    fontSize: 18,
    fontWeight: 'bold',
  },
  loginLink: {
    textAlign: 'center',
    color: COLORS.gray[400],
    fontSize: 14,
    marginTop: 8,
  },
  loginLinkBold: {
    color: COLORS.primary,
    fontWeight: '600',
  },
});

export default WelcomeScreen;
