class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
      type: "text"
    }
    render json: home_keyboard
  end

  def message
    # 텍스트 리턴 기능
    user_message = params[:content]

    menus = ["한식어때요?", "일식어때요?", "중식어때요?", "양식어때요?", "패스트푸드어때요?"]
    return_text = "임시 텍스트"
    image = false

    if user_message == "로또"
      return_text = (1..45).to_a.sample(6).sort.to_s
    elsif user_message == "메뉴"
      return_text = menus.sample
    elsif user_message == "고양이"
      return_text = "고양이를 선택했습니다."
      image = true
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text
    elsif user_message == "영화추천"
      image = true
      url = "http://movie.naver.com/movie/running/current.nhn?view=list&tab=normal&order=reserve"
      movie_html = RestClient.get(url)
      doc = Nokogiri::HTML(movie_html)

      movie_title = Array.new
      movie_info = Hash.new
      doc.css("ul.lst_detail_t1 dt a").each do |title|
        movie_title << title.text
      end
      doc.css("ul.lst_detail_t1 li").each do |movie|
        movie_info[movie.css("dl dt.tit a").text] = {
          :url => movie.css("div.thumb img").attribute('src').to_s,
          :star => movie.css("dl.info_star span.num").text
        }
      end
      sample_movie = movie_title.sample
      return_text = sample_movie + " " + movie_info[sample_movie][:star]
      cat_url = movie_info[sample_movie][:url]
    else
      return_text = "지금 사용가능한 명령어는 <메뉴>, <영화추천>, <로또>, <고양이> 입니다."
    end

    home_keyboard = {
      type: "text"
    }

    return_message = {
      message: {
          text: return_text,
          },
      keyboard: home_keyboard
    }

    return_message_with_img = {
      message: {
        text: return_text,
        photo: {
            url: cat_url,
            width: 720,
            height: 480
        }
      },
      keyboard: home_keyboard
    }

    # 이미지가 있으면 이미지가 있는 메시지를 리턴 아니면 텍스트 메시지를 리턴
    if image
    render json:return_message_with_img
    else
    render json:return_message
    end
  end
end
