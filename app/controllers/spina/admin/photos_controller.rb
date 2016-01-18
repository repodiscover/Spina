module Spina
  module Admin
    class PhotosController < AdminController
      before_filter :set_breadcrumbs

      authorize_resource class: Photo

      layout "spina/admin/media_library"

      def index
        add_breadcrumb I18n.t('spina.website.photos'), spina.admin_photos_path
        @photos = Photo.sorted
        @photo = Photo.new
      end

      def create
        @photo = Photo.create!(photo_params)
        respond_to do |format|
          format.js
          format.json do
            render json: { file_url: @photo.file_url }
          end
        end
      end

      def destroy
        @photo = Photo.find(params[:id])
        @photo.destroy
        redirect_to spina.admin_photos_url
      end

      def enhance
        @photo = Photo.find(params[:id])
        @photo.remote_file_url = params[:new_image]
        @photo.save
      end

      def link
        @photo = Photo.find(params[:id])
      end

      def photo_select
        selected = params[:selected_photo_id] || Array.new
        @photos = Photo.order_by_ids(selected).sorted
        @photo = Photo.new
        @selected_photo = Photo.find(selected)
      end

      def photo_collection_select
        selected = params[:selected_photo_ids] || Array.new
        @photos = Photo.order_by_ids(selected).sorted
        @selected_photos = Photo.where(id: selected)
        @photo = Photo.new
      end

      def insert_photo
        @photo = Photo.find(params[:photo_id]) if params[:photo_id].present?
      end

      def insert_photo_collection
        @photos = Photo.find(params[:photo_ids]) if params[:photo_ids].present?
      end

      def wysihtml5_insert
        @photo = Photo.find(params[:photo_id])
      end

      def wysihtml5_select
        @photos = Photo.sorted
        @photo = Photo.new
      end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('spina.website.media_library'), spina.admin_media_library_path
      end

      def photo_params
        params.require(:photo).permit(:file)
      end

    end
  end
end
