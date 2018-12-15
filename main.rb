require 'twitter'
require 'natto'

ENV['SSL_CERT_FILE'] = File.expand_path('./cacert.pem') #実行時SSLのエラーが出る場合に追記

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['MY_CONSUMER_KEY']
  config.consumer_secret     = ENV['MY_CONSUMER_SECRET']
  config.access_token        = ENV['MY_ACCESS_TOKEN']
  config.access_token_secret = ENV['MY_ACCESS_TOKEN_SECRET']
end

stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV['MY_CONSUMER_KEY']
  config.consumer_secret     = ENV['MY_CONSUMER_SECRET']
  config.access_token        = ENV['MY_ACCESS_TOKEN']
  config.access_token_secret = ENV['MY_ACCESS_TOKEN_SECRET']
end

arr_var = []
arr_meisi = []
arr_josi = []
arr_dousi = []
arr_jodousi = []
arr_setuzokusi = []
arr_kigou = []
arr_fukusi = []
arr_sonota = []

#puts "-------------------- 品詞リスト作成 --------------------"
client.home_timeline.each do |tweet|
  if tweet.is_a?(Twitter::Tweet)
    #puts(tweet.text)
    if !(tweet.text.include?("http")) && !(tweet.user.screen_name == "@hanapipi961_bot")
      natto = Natto::MeCab.new
      natto.parse(tweet.text) do |n|
        arr_var << "#{n.feature.split(',')[0]}"
      end
    end
  end
  #puts arr_var.count
  break if arr_var.count >= 1
end

#puts "-------------------- 品詞配列振り分け ------------------"
client.home_timeline(count: 0).each do |tweet|
  if tweet.is_a?(Twitter::Tweet)
    #puts(tweet.text)
    if !(tweet.text.include?("http")) && !(tweet.user.screen_name == "@hanapipi961_bot")
      natto = Natto::MeCab.new
      natto.parse(tweet.text) do |n|
        if !("#{n.surface}" =~ /^[A-Za-z]+$/) && !("#{n.surface}" == /[0-9]/) && !("#{n.surface}" == "@") && !("#{n.surface}" == "「") && !("#{n.surface}" == "」") && !("#{n.surface}" == "『") && !("#{n.surface}" == "』")
          if "#{n.feature.split(',')[0]}" == "名詞" then
            arr_meisi << "#{n.surface}"
          elsif "#{n.feature.split(',')[0]}" == "助詞" then
            arr_josi << "#{n.surface}"
          elsif "#{n.feature.split(',')[0]}" == "動詞" then
            arr_dousi << "#{n.surface}"
          elsif "#{n.feature.split(',')[0]}" == "助動詞" then
            arr_jodousi << "#{n.surface}"
          elsif "#{n.feature.split(',')[0]}" == "接続詞" then
            arr_setuzokusi << "#{n.surface}"
          elsif "#{n.feature.split(',')[0]}" == "記号" then
            arr_kigou << "#{n.surface}"
          elsif "#{n.feature.split(',')[0]}" == "副詞" then
            arr_fukusi << "#{n.surface}"
          else
            arr_sonota << "#{n.surface}"
          end
        end
      end
    end
  end
end

#puts "-------------------- 配列出力開始 --------------------"
#puts arr_var
#puts arr_meisi.sort_by{rand}
#puts arr_josi = []
str = arr_meisi[rand(arr_meisi.length)] 
strbuf = ""
arr_var.each do |val|
  if "#{val}" == "名詞" then
    str += arr_meisi[rand(arr_meisi.length)] 
  elsif "#{val}" == "助詞" then
    if strbuf == "助詞" then
      #何もしない
    else
      str += arr_josi[rand(arr_josi.length)] 
    end
  elsif "#{val}" == "動詞" then
    str += arr_dousi[rand(arr_dousi.length)] 
  elsif "#{val}" == "助動詞" then
    str += arr_jodousi[rand(arr_jodousi.length)] 
  elsif "#{val}" == "接続詞" then
    str += arr_setuzokusi[rand(arr_setuzokusi.length)] 
  elsif "#{val}" == "記号" then
    str += arr_kigou[rand(arr_kigou.length)] 
  elsif "#{val}" == "副詞" then
    str += arr_fukusi[rand(arr_fukusi.length)] 
  else
    str += arr_sonota[rand(arr_fukusi.length)] 
  end
  strbuf = "#{val}"
  if str.bytesize >= 270 then
    str = str[0,269]
    break
  end
end

random = Random.new
rnd = random.rand(6)
if rnd == 0 then
  str += "りす"
elsif rnd == 1 then
  str += "りす～"
elsif rnd ==2 then
  str += "りすー"
elsif rnd == 3 then
  str += "りす！"
elsif rnd ==4 then
  str += "りす？"
elsif rnd == 5 then
  str += "……"
end
#puts "-------------------- ツイートします --------------------"
#puts str
client.update(str)
