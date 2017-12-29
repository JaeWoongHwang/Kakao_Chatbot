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

    menus = {"한식 추천", "일식 추천", "중식 추천", "양식 추천", "패스트푸드 추천"}
    return_text == "임시 텍스트"
    image = false

    if user_message == "로또"
      return_text = (1..45).to_a.sample(6).to_s.short
    elsif user_message == "메뉴"
      return_text = menus.sample
    elsif user_message == "고양이"
      image = true
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text
    else
      return_text = "지금 사용가능한 명령어는 <메뉴>,<로또>,<고양이> 입니다."
    end

    home_keyboard = {
      type: "text"
    }

    return_message = {
      :message => {
          :text => return_text,
          },
      :keyboard => home_keyboard
    }

    return_message_with_img = {
      :message => {
        :text => return_text,
        :photo => {
            :url => cat_url,
            :width => "720",
            :height => "480"
        }
        },
      :keyboard => home_keyboard
    }

    # 이미지가 있으면 이미지가 있는 메시지를 리턴 아니면 텍스트 메시지를 리턴
    if image
    render json:return_message_with_img
    else
    render json:return_message
    end
end
