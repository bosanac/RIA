module UsersHelper

  # Vraca Gavatar za datog korisnika
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def str_gresaka(broj_gresaka)
    if broj_gresaka == 1
      return " #{broj_gresaka} gresku"
    end
    if broj_gresaka > 1 && broj_gresaka < 5
      return " #{broj_gresaka} greske"
    end
    if broj_gresaka >= 5
      return " #{broj_gresaka} gresaka"
    end
     
  end
  
end