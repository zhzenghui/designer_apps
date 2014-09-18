class VersionsController < ApplicationController

  def create
    @software = Software.find(params[:software_id])
    @version = @software.versions.create(version_params)
    redirect_to software_path(@software)
  end
 
  def show
    @software = Software.find(params[:software_id])
    @version = Version.find(params[:id])

  end

  def modify
  	s = system 'ls'


    @software = Software.find(params[:software_id])
    @version = Version.find(params[:version_id])

    redirect_to software_version_path(@software, @version)

  end 

  def build 
    @software = Software.find(params[:software_id])
    @version = Version.find(params[:version_id])

	flash[:notice] = "正在生 ipa . 稍后可以访问该链接尝试 https://file.i-bejoy.com/"+ @software.app_spell + "/download.html" 


	 FileUtils.mkdir_p File.join(Rails.root, "tmp", "sh")
	zip_path = File.join(Rails.root, "tmp", "sh",    "#{@software.app_id}#{@software.app_spell}.sh")
	FileUtils.rm_rf zip_path

	souce_path = File.join(Rails.root, "app", "assets", "other", "temp.sh")


	logger.info("souce_pathsouce_pathsouce_pathsouce_pathsouce_pathsouce_pathsouce_path")
	logger.info(souce_path)
	logger.info("souce_pathsouce_pathsouce_pathsouce_pathsouce_pathsouce_pathsouce_path")

	# 写入内容  
	# DESGNERID="15"
	# DESGNERNAME="刘彬2"
	# DESGNERSPELLNAME="liubin1"
	# SCHME="DesignerM2"
	# them_id="2"
	# version="1.0"
	file_content = File.read(souce_path)

	content =  "DESGNERID=\"" + @software.app_id.to_s + "\"\n" + "DESGNERNAME=\"" +
	 @software.app_name + "\"\n" + "DESGNERSPELLNAME=\"" + @software.app_spell + "\"\n" + 
	 "SCHME=\"" + @version.schme + "\"\n" + 
	  "them_id=\"" + @version.them_id.to_s + "\"\n" +
	  "version=\"" + @version.number.to_s + "\"\n"  + file_content

	File.open(zip_path, "w+") do |f|
	  f.write(content)
	end


	#2.

	system "chmod +x " + zip_path

	#3.
    system zip_path
    redirect_to software_version_path(@software, @version)

  end 

 

 private


 
    def version_params
      params.require(:version).permit(:number, :schme, :them_id, :software_id)
    end
end
