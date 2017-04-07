class ContactsController < ApplicationController
  def index
    @contacts = Contact.all
  end
  
  def new
    if params[:back]
      @contact = Contact.new(contacts_params) # 引数をつけるとそれがinitializeにわたされる
    else
      @contact = Contact.new #変数定義(@をつけるとインスタンス変数)
    end

  end
  
  def create
    @contact = Contact.create(contacts_params)
    if @contact.save
        redirect_to root_path, notice:"お問い合わせありがとうございました！"
        NoticeMailer.sendmail_contact(@contact).deliver #メール送信
      else
        render 'new'
    end

  end
  
  def confirm
    @contact = Contact.new(contacts_params)
    render:new if @contact.invalid?
    
  end
  
  private
    def contacts_params
      params.require(:contact).permit(:name,:email,:content)
    end
    
end
