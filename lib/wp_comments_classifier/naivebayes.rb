module NaiveBayes
  
  module Util
    # sums up all elements of arr. i.e. returns arr[0] + arr[1] .. + arr[n]
    def sum(arr)
      res = 0
      arr.each{|e| res+=e}
      res
    end

    # multiplies each element of arr. i.e. returns arr[0] * arr[1] .. * arr[n]
    def multiply(arr)
      res = 1
      arr.each{|e| res*=e}
      res
    end

    def self.highest_ranking(classifications, epsilon=0.000001)
      max_class = nil
      max_prob = 0.0
      classifications.each_pair{|klass, prob| max_class, max_prob = klass, prob if prob >= max_prob }
      unclassified = true
      classifications.each_value do |prob|
        if max_prob - prob > epsilon
          unclassified = false
          break
        end
      end
      unclassified ? Unclassified : max_class
    end

    class Unclassified
    private
      def initialize(); end  
    end
  end

  class Classifier
    include Util
    
    def initialize(training, laplace_factor=1.0)
      @laplace_factor = laplace_factor
      # dictionary per class, used to calculate conditional probability of words per class
      @dict = {}
      # dictionary over the whole training set. its size is used in laplace smoothing
      @global_dict = Hash.new(0.0)
      # total words per class
      @total_words = Hash.new(0.0)
      total_messages = 0
      training.each_value{|messages| total_messages += messages.size}
      @priors = {}
      
      # construct dictionaries and count words
      training.each_pair{|klass, messages|
        @dict[klass] = {}
        @dict[klass].default = 0.0
        messages.each{|msg|
          msg.split.each{|word|
          @dict[klass][word] += 1
            @global_dict[word] += 1
            @total_words[klass] += 1
          }
        }
        # calculate prior probability of this class
        # the formula given in lecture 5.21
        #                           count(x) + k                /        N             +      k          *   |x| 
        @priors[klass] = (messages.size.to_f + @laplace_factor) / (total_messages.to_f + @laplace_factor * training.keys.size)
      }
      # store classes
      @classes = training.keys
    end
    
    # conditional probability of word given klass, taking into account laplace smoothing factor
    def prob(word, klass)
      (@dict[klass][word] + @laplace_factor) / (@total_words[klass] + @laplace_factor * @global_dict.size)
    end

    # builds the fraction 
    def classify(message)
      raise ArgumentError("message must be a string") unless message.kind_of? String
      res={}
      words = message.split
      @classes.each{|klass|
        # P(word_1|klass) * P(word_2|klass) * ... * P(word_n|klass) * P(klass). i.e. the probability of these words and this particular class
        numerator = multiply(words.map{|w| prob(w, klass)}) * @priors[klass]
        # sum over each existing class kk, i.e. calculates the total probability of the words over all classes
        # P(word_1|kk_1)*P(word_2|kk_1)*...*P(word_n|kk_1) * P(kk_1) + ... + P(word_1|kk_n)*P(word_2|kk_n)*...*P(word_n|kk_n) * P(kk_n) 
        denominator = sum(@classes.map{|kk| multiply(words.map{|w| prob(w, kk)}) * @priors[kk] })
        res[klass] = numerator/denominator
        # return 0.0 if the result was NaN. this can happen if we have a long message with words that were not in the dictionary
        # i.e. we were multiplying lots of very small probabilities here..
        res[klass] = res[klass].nan? ? 0.0 : res[klass] 
      }
      res
    end
  end
end