################################################################################
# Author: Deepak Luitel                                                        #
# 1. Find the Key Length                                                       #    
# 2. Find the Key                                                              #
# 3. Decrypt the CipherText  Note: A = 0 && Z = 25                             #
################################################################################

# finds the frequency of a part in array
def find_freq(array)
  length = array.length.to_f
  fre = 0
  counts = 0
  ("A".."Z").each {|x|
    if array.include? x
     counts = array.count(x) 
     counts /= length
     fre += (counts * counts)
     end
   }
   return fre
end

#creates independent parts for each key length
def parts_in_array(c, k, cipherText)
  array = Array.new       #creates array for each new parts
    cipherText.split("").each_with_index {|char, i|
      i+=1
      if (i-c)%k == 0 then
        array.push char
      end
    }
    return array
end

#partition the cipher text in k parts k = key length
def partitioning(k, cipherText)
  avg = 0
  c = 1
   until c > k
     array = parts_in_array(c, k, cipherText)
   avg += find_freq(array) 
    c+=1
  end
  avg /= k 
  return avg
end

#-------------------------------- main() -------------------------#
#gets the cipher text from the input console

if ARGV.length > 0 then
  file = open(ARGV[0])
else
  file = STDIN
end

cipherText = gets
cipherText.chomp!

#hash for storing the IC's
ics = Array.new

# repeat the IC on key length from 1 to 10
for k in 1..10
 ics.push  partitioning(k, cipherText) 
end

# choose max of the frequency over closest to .065
keylength = ics.index(ics.max)+1 
puts "Hoooray! Key Length is #{keylength} character long."

# find the key based on the key-length
def find_fr(array)
  length = array.length.to_f
  fre = 0
  counts = 0
  ary = Array.new
  ("A".."Z").each {|x|
     counts = array.count(x) 
     counts /= length
     ary.push(counts)
   }
   return ary
end

#English language frequencies
p = [0.082,0.015,0.028,0.043,0.127,0.022,0.020,
     0.061,0.070,0.002,0.008,0.040,0.024,0.067,
     0.075,0.019,0.001,0.060,0.063,0.091,0.028,
     0.010,0.023,0.001,0.020,0.001]
alphabets=["Z","A","B","C","D","E",
            "F","G","H","I","J","K",
            "L","M","N","O","P","Q",
            "R","S","T","U","V","W",
            "X","Y"]
 
# finding the key from key length
key_int = [] # the keys in numerics 4 21 0 ..
key = [] # the key value in alphabets D S Z ..
for ke in 1..keylength
    array = parts_in_array(ke, keylength, cipherText)
    q = find_fr(array)
    hashs = Hash.new
    for j in 0..25
      sum = 0
        for i in 0..25
          sum += q[(i+j)%26].to_f * p[i].to_f
        end
        hashs["#{(j+1)%26}"] = sum
    end
   intervals = hashs.key(hashs.values.max).to_i
   key_int << intervals
   key << alphabets[intervals]
end

puts "And the key is: #{key.to_s}" 

#--------------------------------X------------------------#
# Decode of  the cipher text with the key
message = ""
cipherText.split("").each_with_index{|c, i|
   message << alphabets[(alphabets.index(c)+1 - key_int[i%keylength]) % 26]
  }
#print the message or save it in the file 
puts message.downcase
puts ""
puts "Want to save the message in a file?(Yes or No)"  
STDOUT.flush
answer = gets.chomp!
if answer == "Yes" then
  f = File.new("messages.txt", "w+")
  f.puts message.downcase
  puts "Done! Saved in the messages.txt file."
  f.close
end
