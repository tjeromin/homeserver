import os
import subprocess
import yaml
import logging
import shutil
from datetime import datetime

class BackupManager:
    def __init__(self, config_file='backup_config.yaml'):
        # Determine the directory where the script is located
        script_dir = os.path.dirname(os.path.abspath(__file__))
        self.config_file = os.path.join(script_dir, config_file)
        self.setup_logging()
        
    def setup_logging(self):
        """Set up logging configuration with both file and console output"""
        logger = logging.getLogger('backup_manager')
        logger.setLevel(logging.INFO)
        
        file_handler = logging.FileHandler('backup_log.txt')
        file_formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
        file_handler.setFormatter(file_formatter)
        
        console_handler = logging.StreamHandler()
        console_formatter = logging.Formatter('[%(levelname)s] %(message)s')
        console_handler.setFormatter(console_formatter)
        
        logger.addHandler(file_handler)
        logger.addHandler(console_handler)
        self.logger = logger
        
    def load_configuration(self):
        """Load backup configuration from YAML file"""
        try:
            self.logger.info(f"Loading configuration from {self.config_file}")
            with open(self.config_file, 'r') as f:
                config = yaml.safe_load(f)
            
            script_dir = os.path.dirname(os.path.abspath(__file__))

            # Resolve folder paths relative to the script's directory
            folders = config.get('folders', [])
            folders = [
                os.path.join(script_dir, folder) if not os.path.isabs(folder) else folder
                for folder in folders
            ]

            # Resolve backup_root path relative to the script's directory
            backup_root = config.get('backup_root', './backups')
            if not os.path.isabs(backup_root):
                backup_root = os.path.join(script_dir, backup_root)

            self.logger.info(f"Found {len(folders)} folders to backup")
            self.logger.info(f"Using backup root directory: {backup_root}")
            
            return folders, backup_root
            
        except FileNotFoundError:
            self.logger.error(f"Configuration file '{self.config_file}' not found")
            raise
        except yaml.YAMLError as e:
            self.logger.error(f"Invalid YAML format in configuration file: {str(e)}")
            raise
            
    def create_backup_structure(self, backup_root):
        """Create the backup directory structure"""
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_dir = os.path.join(backup_root, f'backup_{timestamp}')
        
        try:
            os.makedirs(backup_dir, exist_ok=True)
            self.logger.info(f"Created backup directory: {backup_dir}")
            return backup_dir
        except Exception as e:
            self.logger.error(f"Failed to create backup directory: {str(e)}")
            raise
            
    def backup_folder(self, source_path, backup_path):
        """Backup a single folder using rsync"""
        try:
            relative_path = os.path.basename(source_path)
            final_dest = os.path.join(backup_path, relative_path)

            self.logger.info(f"Backing up '{source_path}' to '{final_dest}' using rsync")

            if os.path.exists(source_path):
                # Use rsync to copy the folder while preserving metadata
                rsync_command = [
                    'rsync', '-a', '--info=progress2', '--delete',
                    source_path + '/', final_dest
                ]
                subprocess.run(rsync_command, check=True)
                self.logger.info(f"Successfully backed up '{source_path}' to '{final_dest}'")
            else:
                self.logger.error(f"Source path '{source_path}' does not exist")

        except subprocess.CalledProcessError as e:
            self.logger.error(f"rsync failed for '{source_path}': {str(e)}")
        except Exception as e:
            self.logger.error(f"Error backing up '{source_path}': {str(e)}")
        
    def delete_oldest_backups(self, backup_root, backup_prefix="backup_"):
        """Delete the oldest backup files if there are more than 3 backups"""
        try:
            self.logger.info(f"Checking for old backups in '{backup_root}'")

            # List all files in the backup_root directory that start with the backup prefix
            backups = [
                os.path.join(backup_root, f) for f in os.listdir(backup_root)
                if f.startswith(backup_prefix)
            ]

            # Sort backups by creation time (oldest first)
            backups.sort(key=lambda f: os.path.getctime(f))

            # If there are more than 3 backups, delete the oldest ones
            while len(backups) > 3:
                oldest_backup = backups.pop(0)
                if os.path.isdir(oldest_backup):
                    shutil.rmtree(oldest_backup)
                else:
                    os.remove(oldest_backup)
                self.logger.info(f"Deleted old backup: {oldest_backup}")

        except Exception as e:
            self.logger.error(f"Failed to delete old backups: {str(e)}")
        
    def run_backup(self):
        """Run the complete backup process"""
        try:
            self.logger.info("Starting backup process...")
            folders, backup_root = self.load_configuration()
            backup_path = self.create_backup_structure(backup_root)
            
            for folder in folders:
                self.backup_folder(folder, backup_path)
            
            # Compress the backup directory
            archive_name = f"{backup_path}.tar.gz"
            self.logger.info(f"Compressing backup directory to '{archive_name}'")
            shutil.make_archive(backup_path, 'gztar', root_dir=backup_path)
            self.logger.info(f"Backup directory compressed successfully: {archive_name}")
            
            # Delete the uncompressed backup folder
            self.logger.info(f"Deleting uncompressed backup folder: '{backup_path}'")
            shutil.rmtree(backup_path)
            self.logger.info(f"Uncompressed backup folder deleted successfully")
            
            # Delete oldest backups if necessary
            self.delete_oldest_backups(backup_root)
            
            self.logger.info("Backup process completed successfully")
            
        except Exception as e:
            self.logger.error(f"Failed to run backup: {str(e)}")

if __name__ == "__main__":
    backup_manager = BackupManager()
    backup_manager.run_backup()