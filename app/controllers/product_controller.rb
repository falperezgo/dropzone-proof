class ProductController < ApplicationController
  def new
  end

  def create
    files_list = ActiveSupport::JSON.decode(params[:files_list])
    product=Product.create(name: params[:name], description: params[:description])
    Dir.mkdir("#{Rails.root}/public/"+product.id.to_s)
    files_list.each do |pic|
      File.rename( "#{Rails.root}/"+pic, "#{Rails.root}/public/"+product.id.to_s+'/'+File.basename(pic))
      product.pics.create(name: pic)
    end
    redirect_to product_new_url, notice: "Success! Product is created."
  end

  def upload_old
    uploaded_pics = params[:file] # Take the files which are sent by HTTP POST request.
    time_footprint = Time.now.to_i.to_formatted_s(:number) # Generate a unique number to rename the files to prevent duplication

    uploaded_pics.each do |pic|
      # these two following comments are some useful methods to debug
      # abort pic.class.inspect -> It is similar to var_dump($variable) in PHP.
      # abort pic.is_a?(Array).inspect -> With "is_a?" method, you can find the type of variable
      # abort pic[1].original_filename.inspect
      # The following snippet saves the uploaded content in '#{Rails.root}/public/uploads' with a name which contains a time footprint + the original file
      # reference: http://guides.rubyonrails.org/form_helpers.html
      File.open(Rails.root.join('public', 'uploads', pic[1].original_filename), 'wb') do |file|
        file.write(pic[1].read)
        File.rename(file, 'public/uploads/' + time_footprint + pic[1].original_filename)
      end
    end
    files_list = Dir['public/uploads/*'].to_json #get a list of all files in the {public/uploads} directory and make a JSON to pass to the server
    render json: { message: 'You have successfully uploded your images.', files_list: files_list } #return a JSON object amd success message if uploading is successful
  end

  def upload
    uploaded_pics = params[:file]
    time_footprint = Time.now.to_i.to_formatted_s(:number)
#abort uploaded_pics.inspect
    uploaded_pics.each do |index,pic|
      File.open(Rails.root.join('public', 'uploads', pic.original_filename), 'wb') do |file|
        file.write(pic.read)
        File.rename(file, 'public/uploads/' + time_footprint + pic.original_filename)
      end
    end
    files_list = Dir['public/uploads/*'].to_json
    render json: { message: 'You have successfully uploded your images.', files_list: files_list }
  end


  def product_params
    params.require(:product).permit(:file)
  end


end
