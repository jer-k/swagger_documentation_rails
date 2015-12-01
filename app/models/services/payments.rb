module Services
  class Payments
    CREDIT_TIERS = {
        1..600 => 'Poor',
        601..650 => 'Fair',
        651..700 => 'Good',
        701..750 => 'Very Good',
        751..1000 => 'Excellent'
    }

    MEDIAN_SCORE_FOR_TIERS = {
        'Poor' => 575,
        'Fair' => 625,
        'Good' => 675,
        'Very Good' => 725,
        'Excellent' => 800
    }

    APR_FOR_TIERS = {
        'Poor' => 12.0,     #Experian subprime/Deep subprime
        'Fair' => 6.49,     #Experian non-prime
        'Good' => 5.0,      #Experian Non-prime/Prime
        'Very Good' => 3.5, #Experian Prime
        'Excellent' => 2.75 #Experian Super-prime
    }

    # Takes a credit score and return the tier the score is in
    # @param score [Integer]
    #
    # @return [String]
    def credit_tier(score)
      CREDIT_TIERS.detect{|k, v| k === score}.last
    end

    # Takes a credit tier and returns the median credit score for that tier
    # @param tier [String]
    #
    # @return [Integer]
    def credit_score(tier)
      MEDIAN_SCORE_FOR_TIERS["#{tier}"]
    end

    # Takes a credit tier and returns a general APR for that tier
    # @param tier [String]
    #
    # @return [Float]
    def apr(tier)
      APR_FOR_TIERS["#{tier}"]
    end
  end
end